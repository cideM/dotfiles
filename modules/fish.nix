{
  config,
  inputs,
  ...
}:
let
  fishConfig = ''
    #  alt+e
    bind \cb edit_command_buffer

    set -x BAT_THEME 'GitHub'
    set -x MANPAGER 'nvim +Man!'

    # https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
    # XDG_RUNTIME_DIR is set by pam_systemd and should not be overridden
    set -x XDG_CONFIG_HOME $HOME/.config
    set -x XDG_DATA_HOME $HOME/.local/share
    set -x XDG_CACHE_HOME $HOME/.cache

    set -x GOPATH ~/go
    set -x GOCACHE $XDG_CACHE_HOME/go-build
  '';
in
{
  flake.modules.homeManager.fish =
    { pkgs, lib, ... }:
    {
      programs.eza = {
        enable = true;
        enableFishIntegration = true;
        git = true;
        icons = "auto";
        extraOptions = [
          "--group-directories-first"
          "--header"
        ];
      };

      programs.fish = {
        enable = true;

        # programs.eza aliases `eza` itself to carry the flags above, so every
        # alias below inherits icons, git status, grouped dirs and a header.
        # It also defines these defaults (overridable, they use mkDefault):
        #   ls  = eza         plain listing, drop-in for ls
        #   ll  = eza -l      long listing: perms, size, date, git status
        #   lla = eza -la     long listing including dotfiles
        shellAliases = {
          # Long listing including dotfiles (module default is just -a)
          la = "eza -la";
          # Two-level tree that skips gitignored files plus the usual noise dirs
          lt = "eza --tree --level=2 --git-ignore --ignore-glob='.git|node_modules|.direnv|result'";
          # Same tree but also shows dotfiles
          lta = "eza --tree --level=2 --git-ignore --ignore-glob='.git|node_modules|.direnv|result' -a";
          # Long listing of directories only
          ld = "eza -lD";
          # Long listing sorted by size, largest last
          lS = "eza -l --sort=size";
          # Long listing sorted by modification time, newest last
          lm = "eza -l --sort=modified";
        };

        shellAbbrs = {
          g = "git";
          gs = "git status";
          gc = "git commit";
          gp = "git push";
          gpr = "gh pr list  --search 'draft:false review:required'";
          gpl = "gh pr list";
          gd = "git diff";
          gw = "git worktree";
          gwl = "git worktree list";
          dc = "docker compose";
          n = "nvim";
          k = "kubectl";
        };

        interactiveShellInit =
          fishConfig
          + lib.optionalString pkgs.stdenv.isDarwin ''
            fish_add_path /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/
            fish_add_path /Applications/Sublime\ Merge.app/Contents/SharedSupport/bin/
            fish_add_path /opt/local/bin /opt/local/sbin

            # MacPorts
            if not contains /opt/local/share/man $MANPATH
              set --append MANPATH /opt/local/share/man
            end
          '';

        functions = {
          gi = {
            description = "Pick commit for interactive rebase";
            body = ''
              set -l commit (git log --oneline --decorate | fzf --preview 'git show (echo {} | awk \'{ print $1 }\')' | awk '{ print $1 }')
              if test -n "$commit"
                git rebase $commit~1 --interactive --autosquash
              end
            '';
          };

          gf = {
            description = "Fixup a commit then autosquash";
            body = ''
              set -l commit (git log --oneline --decorate | fzf --preview 'git show (echo {} | awk \'{ print $1 }\')' | awk '{ print $1 }')
              if test -n "$commit"
                git commit --fixup $commit
                GIT_SEQUENCE_EDITOR=true git rebase $commit~1 --interactive --autosquash
              end
            '';
          };

          gwa = {
            description = "Create a worktree with a new branch next to the current repo";
            body = ''
              read -P 'New branch: ' -l branch
              or return
              if test -z "$branch"
                echo "no branch name given" >&2
                return 1
              end

              set -l base (git for-each-ref --format='%(refname:short)' refs/heads refs/remotes \
                | string match -v -r '/HEAD$' \
                | fzf --prompt 'Start from> ' --preview 'git log --oneline -20 {}')
              if test -z "$base"
                return 1
              end

              set -l root (git rev-parse --show-toplevel)
              or return
              set -l dir (dirname $root)/(string replace --all / - $branch)

              git worktree add $dir -b $branch $base
              and cd $dir
            '';
          };

          gwp = {
            description = "Pick a PR with fzf and check it out in a new worktree next to the current repo";
            body = ''
              set -l pick (gh pr list --limit 100 \
                --json number,headRefName,title,author \
                --template '{{range .}}{{.number}}{{"\t"}}{{.headRefName}}{{"\t"}}{{.title}}{{"\t"}}{{.author.login}}{{"\n"}}{{end}}' \
                | fzf --prompt 'PR> ' --delimiter \t --with-nth 1,3,4 \
                    --preview 'gh pr view {1}' --preview-window 'down,60%,wrap')
              if test -z "$pick"
                return 1
              end

              set -l fields (string split \t -- $pick)
              set -l number $fields[1]
              set -l branch $fields[2]

              set -l root (git rev-parse --show-toplevel)
              or return
              set -l dir (dirname $root)/(string replace --all / - $branch)

              if test -d $dir
                echo "worktree $dir already exists, switching to it" >&2
                cd $dir
                return
              end

              # Start detached so gh can create/fetch the PR branch itself; this
              # also handles PRs from forks.
              git worktree add --detach $dir
              and cd $dir
              and gh pr checkout $number
            '';
          };

          gpd = {
            description = "Dashboard of my open PRs: conflicts, CI, unresolved review threads";
            body = ''
              set -l query '
                query {
                  search(query: "is:pr is:open author:@me archived:false", type: ISSUE, first: 100) {
                    nodes {
                      ... on PullRequest {
                        url number title isDraft
                        repository { nameWithOwner }
                        mergeable
                        reviewDecision
                        commits(last: 1) { nodes { commit { statusCheckRollup { state } } } }
                        reviewThreads(first: 100) { nodes { isResolved } }
                      }
                    }
                  }
                }'

              # GitHub computes mergeable lazily, so right after a base branch
              # moves it reads "?" until the next call. PRs that need work sort
              # first. The URL column is hidden and feeds the preview/enter.
              set -l rows (gh api graphql -f query=$query --jq '
                ["URL", "PR", "MERGE", "CI", "THREADS", "REVIEW", "TITLE"],
                (.data.search.nodes
                  | map({
                      url,
                      pr: "\(.repository.nameWithOwner)#\(.number)",
                      merge: ({MERGEABLE: "ok", CONFLICTING: "CONFLICT"}[.mergeable] // "?"),
                      ci: ({SUCCESS: "ok", PENDING: "pending", EXPECTED: "pending", FAILURE: "FAIL", ERROR: "FAIL"}[.commits.nodes[0].commit.statusCheckRollup.state // ""] // "-"),
                      threads: ([.reviewThreads.nodes[] | select(.isResolved | not)] | length),
                      review: (.reviewDecision // "-" | ascii_downcase),
                      title: ((if .isDraft then "[draft] " else "" end) + .title)
                    })
                  | sort_by(.merge != "CONFLICT" and .ci != "FAIL" and .threads == 0)
                  | .[]
                  | [.url, .pr, .merge, .ci, .threads, .review, .title])
                | @tsv')
              or return

              printf '%s\n' $rows | column -t -s \t \
                | fzf --layout reverse --header-lines 1 --with-nth 2.. --no-sort \
                    --preview 'gh pr view {1}' --preview-window 'down,60%,wrap' \
                    --bind 'enter:execute-silent(gh pr view --web {1})'
            '';
          };

          fish_greeting = {
            body = "";
          };

          fish_title = {
            description = "Set terminal tab title";
            body = ''
              set -l branch (git branch --show-current 2>/dev/null)
              if test -n "$branch"
                echo "$branch "(basename $PWD)
              else
                string join / -- (string split / -- $PWD)[-2..-1]
              end
            '';
          };
        };

        plugins = [
          {
            name = "nix-env";
            src = inputs.nix-fish-src;
          }

          {
            name = "yui";
            src = inputs.yui.packages.${pkgs.stdenv.hostPlatform.system}.fish_light.src;
          }

          {
            name = "hydro";
            src = pkgs.fishPlugins.hydro.src;
          }
        ];
      };
    };
}
