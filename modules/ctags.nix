{ ... }:
{
  xdg.configFile."ctags/1.ctags".text = ''
    --exclude=compiled
    --exclude=build
    --exclude=min
    --exclude=vendor
    --exclude='*.min.*'
    --exclude='*.map'
    --exclude='*.swp'
    --exclude='*.bak'
    --exclude=tags
    --exclude=dist
    --exclude='*.json'
  '';

  xdg.configFile."ctags/javascript.ctags".text = ''
    --exclude=node_modules
    --exclude=project.json
    --exclude=package-lock.json
    --exclude=yarn.lock
  '';

  xdg.configFile."ctags/go.ctags".text = ''
    --exclude=go.mod
    --exclude=go.sum
  '';

  xdg.configFile."ctags/rust.ctags".text = ''
    --exclude=target
  '';
}
