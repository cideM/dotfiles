{pkgs, ...}: {
  # Can't use programs.git because https://github.com/NixOS/nixpkgs/issues/62353
  xdg.configFile."git/config".text = ''
    [push]
        default = simple

    [diff]
        algorithm = histogram
        colorWords = true
        colorMoved = default
        noprefix = true
        wordRegex = "\\w+|."

    [diff "lockb"]
        binary = true
        textconv = ${pkgs.bun}/bin/bun

    [pull]
        rebase = true

    [merge]
        tool = nvimdiff1
        conflictStyle = zdiff3

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

    [filter "lfs"]
        clean = git-lfs clean -- %f
        smudge = git-lfs smudge -- %f
        process = git-lfs filter-process
        required = true

    [url "git@github.com:"]
        insteadOf = https://github.com/
  '';
}
