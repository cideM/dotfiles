{ config, ... }:
{
  home.file.".pandoc/templates/eisvogel.latex".source = "${config.sources.pandoc-template-eisvogel}/eisvogel.tex";
  home.file.".pandoc/templates/GitHub.html5".source = "${config.sources.pandoc-template-github}/templates/html5/github/GitHub.html5";
}
