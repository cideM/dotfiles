{ ... }:
{
  xdg.configFile."ctags/1.ctags".text = ''
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
