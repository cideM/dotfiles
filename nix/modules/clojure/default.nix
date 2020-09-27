{ ... }:
let
  sources = import ./nix/sources.nix;

in
{
  xdg.configFile."clojure/deps.edn".source = "${sources.clj-deps}/deps.edn";
}
