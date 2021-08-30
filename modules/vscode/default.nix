{ pkgs, config, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;

  archive_fmt = if (system == "x86_64-darwin" || system == "aarch64-darwin") then "zip" else "tar.gz";

  plat = {
    x86_64-linux = "linux-x64";
    x86_64-darwin = "darwin";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
    armv7l-linux = "linux-armhf";
  }.${system};

  sha = {
    x86_64-linux = "sha256:1bqyg0996aqbih6f93qqphgfs8lg334hlr2byydz1x7fgyvjsnch";
    x86_64-darwin = "sha256:11rnr41200sbi4rzsxlc0l5fdr0fvpqmz0sfkh8ap1r18g7i89ym";
    aarch64-darwin = "sha256:0nh4mfxsw4nhfnznjv5grjfzinvxa0sr86xzl6rnsxyhnpq1pn89";
  }.${system};

  version = "latest";

  latest = pkgs.vscode.overrideAttrs
    (_: rec {
      pname = "vscode-insiders";
      # https://matrix.to/#/!YllBCgVdcoakoavZvX:rycee.net/$_MrTYFXF00sFE0yt86qljP2svFzeRxJfgcXVo8R9oGg?via=matrix.org&via=nerdsin.space&via=nixos.dev
      # I couldn't find links to download specific versions of the insiders
      # release. There appears to be only the 'latest' version of it. This
      # confuses 'niv', since it won't update the hash if the link never
      # changes. When Nix then downloads the source, it sees a different
      # hash. Long story short: I'll just have to update the hash here all
      # the time and can't use 'niv' for this.
      src = builtins.fetchurl {
        name = "VSCode_${version}_${plat}.${archive_fmt}";
        url = "https://update.code.visualstudio.com/${version}/${plat}/insider";
        sha256 = sha;
      };
    });

  marketplace =
    let exts = (builtins.filter ({ name, ... }: if pkgs.stdenv.isDarwin then true else name != "vsliveshare") (import ./shared_exts.nix));
    in pkgs.vscode-utils.extensionsFromVscodeMarketplace exts;

  # https://github.com/NixOS/nixpkgs/pull/110461
  platformExts = with pkgs.vscode-extensions; if pkgs.stdenv.isDarwin then [ ] else [ ms-vsliveshare.vsliveshare ];

  extensions = platformExts ++ marketplace;
in
{
  programs.vscode = {
    enable = true;
    keybindings = pkgs.lib.importJSON ./keybindings.json;
    package = latest;
    extensions = extensions;
    userSettings = {
      "editor.minimap.showSlider" = "always";
      "editor.wrappingIndent" = "indent";
      "editor.wordWrapColumn" = 120;
      "editor.suggestSelection" = "first";
      "editor.multiCursorModifier" = "ctrlCmd";
      "editor.renderIndentGuides" = true;
      "editor.semanticHighlighting.enabled" = true;
      "editor.lineNumbers" = "off";
      "editor.renderLineHighlight" = "all";
      "editor.wordWrap" = "on";
      "editor.overviewRulerBorder" = false;
      "editor.hideCursorInOverviewRuler" = true;
      "editor.snippetSuggestions" = "top";
      "editor.codeActionsOnSave" = {
        "source.fixAll.eslint" = true;
      };
      "editor.quickSuggestions" = {
        "other" = true;
        "comments" = true;
        "strings" = true;
      };
      "editor.fontLigatures" = true;
      "editor.acceptSuggestionOnEnter" = "smart";
      "editor.minimap.renderCharacters" = false;
      "editor.formatOnSave" = true;
      "editor.minimap.side" = "left";
      "editor.matchBrackets" = "always";
      "editor.renderWhitespace" = "selection";
      "git.autofetch" = true;
      "git.confirmSync" = false;
      "git.enableSmartCommit" = true;
      "terminal.integrated.rendererType" = "experimentalWebgl";
      "terminal.integrated.minimumContrastRatio" = 7;
      "terminal.integrated.scrollback" = 10000;
      "terminal.integrated.cursorBlinking" = true;
      "terminal.integrated.copyOnSelection" = true;
      "terminal.integrated.allowChords" = false;
      "terminal.integrated.profiles.osx" = {
        "fish" = {
          "path" = "${pkgs.fish}/bin/fish";
          "args" = [ "-l" ];
        };
      };
      "terminal.integrated.profiles.linux" = {
        "fish" = {
          "path" = "${pkgs.fish}/bin/fish";
          "args" = [ "-l" ];
        };
      };
      "terminal.integrated.defaultProfile.osx" = "fish";
      "terminal.integrated.defaultProfile.linux" = "fish";
      "terminal.integrated.automationShell.osx" = "${pkgs.bash_5}/bin/bash";
      "terminal.integrated.automationShell.linux" = "${pkgs.bash_5}/bin/bash";
      "terminal.integrated.drawBoldTextInBrightColors" = true;
      "terminal.integrated.commandsToSkipShell" = [
        "workbench.action.terminal.toggleTerminal"
        "workbench.action.toggleFullScreen"
        "workbench.action.toggleMaximizedPanel"
        "workbench.action.togglePanelPosition"
        "workbench.action.togglePanel"
        "workbench.action.toggleSidebarVisibility"
        "workbench.action.toggleEditorVisibility"
      ];
      "outline.showTypeParameters" = true;
      "workbench.editor.enablePreview" = false;
      "workbench.statusBar.visible" = true;
      "workbench.editor.highlightModifiedTabs" = true;
      "workbench.editor.closeOnFileDelete" = true;
      "workbench.sideBar.location" = "right";
      "workbench.editor.revealIfOpen" = false;
      "workbench.editor.showTabs" = false;
      "workbench.useExperimentalGridLayout" = true;
      "workbench.settings.editor" = "json";
      "window.openFoldersInNewWindow" = "off";
      "window.menuBarVisibility" = "hidden";
      "window.titleBarStyle" = "custom";
      "window.newWindowDimensions" = "inherit";
      "window.restoreFullscreen" = true;
      "window.restoreWindows" = "all";
      "problems.showCurrentInStatus" = true;
      "typescript.updateImportsOnFileMove.enabled" = "prompt";
      "npm.packageManager" = "yarn";
      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;
      "explorer.openEditors.visible" = 0;
      "files.simpleDialog.enable" = true;
      "files.trimFinalNewlines" = true;
      "files.exclude" = {
        "**/.DS_Store" = true;
        "**/.git" = true;
        "**/.hg" = false;
        "**/.svn" = false;
        "**/.spago" = true;
        "**/.idea" = true;
        "**/CVS" = false;
        "**/output" = true;
        "**/.classpath" = true;
        "**/.project" = true;
        "**/.settings" = true;
        "**/.factorypath" = true;
      };
      "search.exclude" = {
        "**/dist" = true;
      };
      "javascript.validate.enable" = false;
      "javascript.suggest.completeFunctionCalls" = true;
      "javascript.updateImportsOnFileMove.enabled" = "prompt";
      "javascript.suggest.autoImports" = false;
      "search.smartCase" = true;
      "zenMode.restore" = true;
      "markdown.preview.lineHeight" = 1.2;
      "markdown.preview.fontSize" = 15;
      "[javascript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[html]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[haskell]" = {
        "editor.defaultFormatter" = "sjurmillidahl.ormolu-vscode";
      };
      "[javascriptreact]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[typescript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[markdown]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[yaml]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[json]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[jsonc]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "diffEditor.renderSideBySide" = false;
      "merge-conflict.diffViewPosition" = "Below";
      "scm.diffDecorations" = "all";
      "scm.diffDecorationsGutterWidth" = 2;
      "typescript.suggest.completeFunctionCalls" = true;
      "debug.node.autoAttach" = "off";
      "breadcrumbs.enabled" = false;
      "go.formatTool" = "gofmt";
      "go.buildOnSave" = "workspace";
      "go.lintOnSave" = "file";
      "go.liveErrors" = {
        "enabled" = true;
        "delay" = 500;
      };
      "go.lintTool" = "golangci-lint";
      "go.lintFlags" = [ "--fast" ];
      "go.useLanguageServer" = true;
      "sql-formatter.dialect" = "sql";
      "rust.clippy_preference" = "on";
      "eslint.run" = "onType";
      "purty.pathToPurty" = "purty";
      "purescript.addSpagoSources" = true;
      "purescript.addNpmPath" = true;
      "purescript.buildCommand" = "spago build --purs-args --json-errors";
      "fileutils.rename.closeOldTab" = true;
      "fileutils.move.closeOldTab" = true;
      "emmet.includeLanguages" = {
        "ejs" = "html";
        "javascript" = "javascriptreact";
      };
      "rewrap.wrappingColumn" = 80;
      "spellright.configurationScope" = "user";
      "spellright.language" = [ "en" ];
      "spellright.documentTypes" = [ ];
      "spellright.notificationClass" = "warning";
      "vsintellicode.modify.editor.suggestSelection" = "automaticallyOverrodeDefaultValue";
      "python.insidersChannel" = "off";
      "update.mode" = "none";
      "latex-workshop.view.pdf.viewer" = "tab";
      "latex-workshop.latex.autoBuild.run" = "never";
      "editor.largeFileOptimizations" = false;
      "calva.paredit.defaultKeyMap" = "strict";
      "workbench.colorTheme" = "Atom One Light";
      "editor.fontFamily" = "Operator Mono SSm";
      "editor.fontSize" = 15;
      "editor.minimap.enabled" = false;
    };
  };
}
