{ sources, ... }:

let
  config = {
    xdg.configFile."clojure/deps.edn".source = "${sources.clj-deps}/deps.edn";
  };
in
{
  inherit config;
}
