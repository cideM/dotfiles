{ pkgs, ... }:
{
  # Can't use programs.git because https://github.com/NixOS/nixpkgs/issues/62353
  xdg.configFile."git/config".text = ''
    [column]
        ui = auto

    [push]
        default = simple
        autoSetupRemote = true
        followTags = true

    [help]
        autocorrect = prompt

    [gpg]
        program = ${pkgs.gnupg}/bin/gpg

    [commit]
        verbose = true

    [rerere]
        enabled = true
        autoupdate = true

    [fetch]
        prune = true
        pruneTags = true
        all = true

    [branch]
        sort = -committerdate

    [tag]
        sort = version:refname

    [init]
        defaultBranch = main

    [diff]
        algorithm = histogram
        colorMoved = plain
        renames = true
        mnemonicPrefix = true
        noprefix = true

    [diff "lockb"]
        binary = true
        textconv = ${pkgs.bun}/bin/bun

    [pull]
        rebase = true

    [rebase]
        autoSquash = true
        autoStash = true
        updateRefs = true

    [merge]
        tool = nvimdiff1
        conflictStyle = zdiff3

    [mergetool]
        keepBackup = false

    [mergetool "nvimdiff1"]
        hideResolved = true
        keepBackup = false
        prompt = false

    [alias]
        mt = mergetool

    [user]
        email = yuuki@protonmail.com
        name = Florian Beeres

    [github]
        user = "yuuki@protonmail.com"

    [core]
        editor = nvim
        excludesfile = ~/.gitignore
        pager = 'less'

    [filter "lfs"]
        clean = git-lfs clean -- %f
        smudge = git-lfs smudge -- %f
        process = git-lfs filter-process
        required = true

    [url "git@github.com:"]
        insteadOf = https://github.com/
  '';
}
