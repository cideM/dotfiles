{ sources, ... }:

{
  home.file.".pandoc/templates/eisvogel.latex".source = "${sources.pandoc-template-eisvogel}/eisvogel.tex";
  home.file.".pandoc/templates/GitHub.html5".source = "${sources.pandoc-template-github}/templates/html5/github/GitHub.html5";
}
