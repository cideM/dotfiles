# TODO: Turn into module
{
  xdg.configFile.ctags.text = ''
    --exclude=node_modules
    --exclude=package-lock.json
    --exclude=yarn.lock
    --exclude=compiled
    --exclude=build
    --exclude=min
    --exclude=vendor
    --exclude=\*.min.\*
    --exclude=\*.map
    --exclude=\*.swp
    --exclude=\*.bak
    --exclude=tags
    --exclude=dist
  '';
}
