{ pkgs, config, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;

  archive_fmt = if system == "x86_64-darwin" then "zip" else "tar.gz";

  plat = {
    x86_64-linux = "linux-x64";
    x86_64-darwin = "darwin";
    aarch64-linux = "linux-arm64";
    armv7l-linux = "linux-armhf";
  }.${system};

  sha = {
    x86_64-linux = "sha256:1yhvf4sis5cd03dd0dvcfyyfhindscfmjr4dyznhkj70mchybaq0";
    x86_64-darwin = "sha256:11rnr41200sbi4rzsxlc0l5fdr0fvpqmz0sfkh8ap1r18g7i89ym";
  }.${system};

  version = "latest";

  latest = (pkgs.vscode.override {
    isInsiders = true;
  }).overrideAttrs
    (_: rec {
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

  marketplace = pkgs.vscode-utils.extensionsFromVscodeMarketplace ([
    {
      name = "vscode-sql-formatter";
      publisher = "adpyke";
      version = "1.4.4";
      sha256 = "06q78hnq76mdkhsfpym2w23wg9wcpikpfgz07mxk1vnm9h3jm2l3";
    }
    {
      name = "vscode-theme-onelight";
      publisher = "akamud";
      version = "2.2.3";
      sha256 = "1mzd77sv6lb6kfv5fvdvzggs488q553cf752byrml981ys9r7khz";
    }
    {
      name = "nixpkgs-fmt";
      publisher = "B4dM4n";
      version = "0.0.1";
      sha256 = "1gvjqy54myss4w1x55lnyj2l887xcnxc141df85ikmw1gr9s8gdz";
    }
    {
      name = "Nix";
      publisher = "bbenoist";
      version = "1.0.1";
      sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
    }
    {
      name = "calva";
      publisher = "betterthantomorrow";
      version = "2.0.172";
      sha256 = "0k6i3w77340snnnhhmc8ql9bl9a7krknpzdn2n3m4plk34z4q3fr";
    }
    {
      name = "markdown-checkbox";
      publisher = "bierner";
      version = "0.1.3";
      sha256 = "1zl32jq59phr0w0q3b9w0dhlvr2fgbsycx8zn99swf594rjpkyw5";
    }
    {
      name = "markdown-emoji";
      publisher = "bierner";
      version = "0.0.9";
      sha256 = "18v145ai057nr31sjn4pf0zjg9yxjg376f3wbsb7hcdpyz90vfvw";
    }
    {
      name = "markdown-footnotes";
      publisher = "bierner";
      version = "0.0.7";
      sha256 = "1k6qsg8al95pij9nd43l7n1zfw0sadpagqz1s8paja1qhgxw5fc5";
    }
    {
      name = "markdown-yaml-preamble";
      publisher = "bierner";
      version = "0.0.4";
      sha256 = "03dp1wp5rqxrmsvpkwha38jgaxd1xm51cj4pl26j565ncrmczcx5";
    }
    {
      name = "vscode-styled-jsx";
      publisher = "blanu";
      version = "2.0.0";
      sha256 = "0pnvy0qwwyh2z4jivxkrxc9yy3mhr1zjvxv60b5lbz8a4ghkjk74";
    }
    {
      name = "vscode-intelephense-client";
      publisher = "bmewburn";
      version = "1.6.3";
      sha256 = "0h34hrx20skkvrzcc54glm5irl5ifndb879wn5c1cz9lw47mnzaa";
    }
    {
      name = "better-toml";
      publisher = "bungcip";
      version = "0.3.2";
      sha256 = "08lhzhrn6p0xwi0hcyp6lj9bvpfj87vr99klzsiy8ji7621dzql3";
    }
    {
      name = "npm-intellisense";
      publisher = "christian-kohler";
      version = "1.3.1";
      sha256 = "14kjxiavw5gppv6m0wk54ac03rbsmkxc46cqwsmyiz4p2374rvz4";
    }
    {
      name = "path-intellisense";
      publisher = "christian-kohler";
      version = "2.3.0";
      sha256 = "1wyp3k4gci1i64nrry12il6yflhki18gq2498z3nlsx4yi36jb3l";
    }
    {
      name = "vscode-markdownlint";
      publisher = "DavidAnson";
      version = "0.39.0";
      sha256 = "1k5rmp8y5mlknx585qk0hnvn0jlcdhgpvqwvjw1jqj4b14dqcq63";
    }
    {
      name = "mustache";
      publisher = "dawhite";
      version = "1.1.1";
      sha256 = "1j8qn5grg8v3n3v66d8c77slwpdr130xzpv06z1wp2bmxhqsck1y";
    }
    {
      name = "vscode-eslint";
      publisher = "dbaeumer";
      version = "2.1.14";
      sha256 = "113w2iis4zi4z3sqc3vd2apyrh52hbh2gvmxjr5yvjpmrsksclbd";
    }
    {
      name = "dhall-lang";
      publisher = "dhall";
      version = "0.0.4";
      sha256 = "0sa04srhqmngmw71slnrapi2xay0arj42j4gkan8i11n7bfi1xpf";
    }
    {
      name = "javascript-ejs-support";
      publisher = "DigitalBrainstem";
      version = "1.3.1";
      sha256 = "0dgf6cyqd3jhwr9apxyzkmr2x3a3nr1xbq2glh0y88y8p4j51d29";
    }
    {
      name = "xml";
      publisher = "DotJoshJohnson";
      version = "2.5.1";
      sha256 = "1v4x6yhzny1f8f4jzm4g7vqmqg5bqchyx4n25mkgvw2xp6yls037";
    }
    {
      name = "EditorConfig";
      publisher = "EditorConfig";
      version = "0.16.4";
      sha256 = "0fa4h9hk1xq6j3zfxvf483sbb4bd17fjl5cdm3rll7z9kaigdqwg";
    }
    {
      name = "json-tools";
      publisher = "eriklynd";
      version = "1.0.2";
      sha256 = "0g5ppkc0rpqaprb3l0dsdkzcgmb24apjrq88bw77qll2ra2n7l7f";
    }
    {
      name = "prettier-vscode";
      publisher = "esbenp";
      version = "5.9.2";
      sha256 = "03dvrf028909d186i23kmcpm83xzgrgm3fmiqh94vcs1g6pqdsvl";
    }
    {
      name = "go";
      publisher = "golang";
      version = "0.22.1";
      sha256 = "1gbb13gmif2zzia49153czk3ib6lgwg37gx8gzs4773m9x5hmb2l";
    }
    {
      name = "vscode-graphql";
      publisher = "GraphQL";
      version = "0.3.15";
      sha256 = "03p7xwa6li29fraav2ka4p0i8k9a9ghzyaw51ap91ysawc5xymbg";
    }
    {
      name = "iceberg";
      publisher = "harg";
      version = "1.2.0";
      sha256 = "0ry1zqiqmh6f3sw32mpr2sax18wwac9khgl41lc8gknikrxp7a8p";
    }
    {
      name = "haskell-linter";
      publisher = "hoovercj";
      version = "0.0.6";
      sha256 = "0fb71cbjx1pyrjhi5ak29wj23b874b5hqjbh68njs61vkr3jlf1j";
    }
    {
      name = "latex-workshop";
      publisher = "James-Yu";
      version = "8.16.0";
      sha256 = "0jjqxr20c7zzvxypwp553gwwxz0rzcz6g4gg7gg5kvvx08nfxc3g";
    }
    {
      name = "hoogle-vscode";
      publisher = "jcanero";
      version = "0.0.7";
      sha256 = "0ndapfrv3j82792hws7b3zki76m2s1bfh9dss1xjgcal1aqajka1";
    }
    {
      name = "svg";
      publisher = "jock";
      version = "1.4.5";
      sha256 = "126hsfk939bzblg67hhvy5zvaqfh8rhp880bd3gpy6ijk0bmhgba";
    }
    {
      name = "vscode-styled-components";
      publisher = "jpoissonnier";
      version = "1.5.0";
      sha256 = "19mkw2x0g7yssndp112s3fyr9rydk1cpxl4dzvwj8x950x680pki";
    }
    {
      name = "vscode-random";
      publisher = "jrebocho";
      version = "1.9.0";
      sha256 = "0risgd2y931578xdk14ii7vi33b33mbssv0hkwkbqha5xwnmnvrp";
    }
    {
      name = "vscode-insertdatestring";
      publisher = "jsynowiec";
      version = "2.3.0";
      sha256 = "0p8sjjw2nyvdr41db9h6kmxrwx34w3jp02jsl7gdbdz4n14a65xw";
    }
    {
      name = "language-haskell";
      publisher = "justusadam";
      version = "3.3.0";
      sha256 = "1285bs89d7hqn8h8jyxww7712070zw2ccrgy6aswd39arscniffs";
    }
    {
      name = "center-editor-window";
      publisher = "kaiwood";
      version = "2.3.0";
      sha256 = "0vwvf9awcmcirwwfh9pnh6jlfi73yizn85vmvx1r1sx0z996fa8z";
    }
    {
      name = "tera";
      publisher = "karunamurti";
      version = "0.0.5";
      sha256 = "0mmd7x9k1pwbgasx8lhqn9wqvc3g99g9rimzsya0ng670gfvj2wr";
    }
    {
      name = "Lua";
      publisher = "keyring";
      version = "0.0.9";
      sha256 = "1vgv37qqgdz5dy49ixq4yxr5p9qij2z3x80dk5bbl4ny0nkbs090";
    }
    {
      name = "AWK";
      publisher = "luggage66";
      version = "0.0.2";
      sha256 = "08lqaf0c5sb12yv2ydsfhj2vb89j336valr7ywlmg0541iaxwnpi";
    }
    {
      name = "fish-ide";
      publisher = "lunaryorn";
      version = "0.4.0";
      sha256 = "06pdiazxl4xpql6xcmv1sz77i2dcj7mfjsfdxbsa5cky007sqifh";
    }
    {
      name = "min-theme";
      publisher = "miguelsolorio";
      version = "1.4.7";
      sha256 = "00whlmvx4k6qvfyqdmhyx7wvmhj180fh0yb8q4fgdr9bjiawhlyb";
    }
    {
      name = "dotenv";
      publisher = "mikestead";
      version = "1.0.1";
      sha256 = "0rs57csczwx6wrs99c442qpf6vllv2fby37f3a9rhwc8sg6849vn";
    }
    {
      name = "file-downloader";
      publisher = "mindaro-dev";
      version = "1.0.10";
      sha256 = "01gagdrxb8q0kz81gk3dd42y3ijafxjdhhhssc6s0j3lm807g4m6";
    }
    {
      name = "find-jump";
      publisher = "mksafi";
      version = "1.2.4";
      sha256 = "1qk2sl3dazna3zg6nq2m7313jdl67kxm5d3rq0lfmi6k1q2h9sd7";
    }
    {
      name = "theme-monokai-pro-vscode";
      publisher = "monokai";
      version = "1.1.18";
      sha256 = "0dg68z9h84rpwg82wvk74fw7hyjbsylqkvrd0r94ma9bmqzdvi4x";
    }
    {
      name = "python";
      publisher = "ms-python";
      version = "2021.2.576481509";
      sha256 = "0yj7h14jx1nzwzrwr9d5vpy65r56d6h5jyrk04q34qx8wf02zmx0";
    }
    {
      name = "jupyter";
      publisher = "ms-toolsai";
      version = "2021.2.576440691";
      sha256 = "0dia2qbvmfc1ijswng39ni3imqssib2bnclwk3lr8bmkl31xg5sh";
    }
    {
      name = "remote-containers";
      publisher = "ms-vscode-remote";
      version = "0.160.0";
      sha256 = "0raijm4bn6qvvsr2r46ha6786wi5brji6417qfqwq3dk5c25g4fl";
    }
    {
      name = "remote-ssh";
      publisher = "ms-vscode-remote";
      version = "0.64.0";
      sha256 = "0bj41yf7ab5n0rill2j967x29cj63yv6m6msj1gyz4mrq7svv95s";
    }
    {
      name = "remote-ssh-edit";
      publisher = "ms-vscode-remote";
      version = "0.64.0";
      sha256 = "1n35m928vfr7xhn7kc8hp8q302nnbvkpfb0jpi0di05k8c4vb033";
    }
    {
      name = "remote-wsl";
      publisher = "ms-vscode-remote";
      version = "0.54.0";
      sha256 = "03jjz32r6z20sn9yhv580sksg47rqlyym1a72dnnkahsisr1gj1x";
    }
    {
      name = "vscode-remote-extensionpack";
      publisher = "ms-vscode-remote";
      version = "0.20.0";
      sha256 = "04wrbfsb8p258pnmqifhc9immsbv9xb6j3fxw9hzvw6iqx2v3dbi";
    }
    {
      name = "vscode-typescript-tslint-plugin";
      publisher = "ms-vscode";
      version = "1.3.3";
      sha256 = "1xjspcmx5p9x8yq1hzjdkq3acq52nilpd9bm069nsvrzzdh0n891";
    }
    {
      name = "vscode-purty";
      publisher = "mvakula";
      version = "0.6.0";
      sha256 = "1h4qdfpsmq448gqqrl9svfn8ybmxghsbg2vwm7ywabj3cgd5hxr0";
    }
    {
      name = "color-highlight";
      publisher = "naumovs";
      version = "2.3.0";
      sha256 = "1syzf43ws343z911fnhrlbzbx70gdn930q67yqkf6g0mj8lf2za2";
    }
    {
      name = "ide-purescript";
      publisher = "nwolverson";
      version = "0.23.3";
      sha256 = "1qg7qvkirp2hmf6agplprw0hxl3zg0z83fw04agdmgy8dmpmn0ih";
    }
    {
      name = "language-purescript";
      publisher = "nwolverson";
      version = "0.2.4";
      sha256 = "16c6ik09wj87r0dg4l0swl2qlqy48jkavpp5i90l166x2mjw2b7w";
    }
    {
      name = "vetur";
      publisher = "octref";
      version = "0.32.0";
      sha256 = "0wk6y6r529jwbk6bq25zd1bdapw55f6x3mk3vpm084d02p2cs2gl";
    }
    {
      name = "gatito-theme";
      publisher = "pawelgrzybek";
      version = "0.2.3";
      sha256 = "0p1444ngcncbxg2r9z9v3a8pbc25m9g9rpcy86mzgi39514m8s4v";
    }
    {
      name = "ruby";
      publisher = "rebornix";
      version = "0.28.1";
      sha256 = "179g7nc6mf5rkha75v7rmb3vl8x4zc6qk1m0wn4pgylkxnzis18w";
    }
    {
      name = "vscode-yaml";
      publisher = "redhat";
      version = "0.15.0";
      sha256 = "02n1pfn80c2sd0chipgrpc668kvc3jjj5mza6ywb7ygl7whqbby8";
    }
    {
      name = "json-organizer";
      publisher = "rintoj";
      version = "0.0.4";
      sha256 = "1byw7wzp4yb5l5ppghhacqq2lf4qdqw88bhsdgnwlsflf5gky3bh";
    }
    {
      name = "rust";
      publisher = "rust-lang";
      version = "0.7.8";
      sha256 = "039ns854v1k4jb9xqknrjkj8lf62nfcpfn0716ancmjc4f0xlzb3";
    }
    {
      name = "elm";
      publisher = "sbrink";
      version = "0.26.0";
      sha256 = "0lcjjq710lrarzswidi7yhiyfa96byi9qd146pzjmpxggkj2jmw5";
    }
    {
      name = "night-owl";
      publisher = "sdras";
      version = "2.0.0";
      sha256 = "1s75bp9jdrbqiimf7r36hib64dd83ymqyml7j7726rab0fvggs8b";
    }
    {
      name = "hfmt-vscode";
      publisher = "sergey-kintsel";
      version = "0.1.1";
      sha256 = "1ryfb7kp47qw4xs36fj7ij84hjv1ambvlflgjwyxwwmwx9w8vcgd";
    }
    {
      name = "mdx";
      publisher = "silvenon";
      version = "0.1.0";
      sha256 = "1mzsqgv0zdlj886kh1yx1zr966yc8hqwmiqrb1532xbmgyy6adz3";
    }
    {
      name = "fish-vscode";
      publisher = "skyapps";
      version = "0.2.1";
      sha256 = "0y1ivymn81ranmir25zk83kdjpjwcqpnc9r3jwfykjd9x0jib2hl";
    }
    {
      name = "rewrap";
      publisher = "stkb";
      version = "1.14.0";
      sha256 = "0phffzqv1nmwsgcx6abgzbzw95zc0zlnhsjv2grs5mcsgrghl759";
    }
    {
      name = "lua";
      publisher = "sumneko";
      version = "1.15.1";
      sha256 = "12ph1v0kgjbblwjyclx5a8wlisvwfvhvpj8i2j5kqzbbr5a5rzmk";
    }
    {
      name = "sass-indented";
      publisher = "syler";
      version = "1.8.15";
      sha256 = "0lvwvx6nhjv2ipwcbp2srdpblqxbd0vhs1daji8gdf3dba67w5yb";
    }
    {
      name = "language-stylus";
      publisher = "sysoev";
      version = "1.11.0";
      sha256 = "1bfk6yvrvanfmhwdqv71s3l7myicib7ljv1ixsidwamckv74gidw";
    }
    {
      name = "latex-utilities";
      publisher = "tecosaur";
      version = "0.3.7";
      sha256 = "05clfs2bkyd9m905m5xcs04lwwdacbzy2r0k18hw47jrl60pkkgw";
    }
    {
      name = "import-to-require";
      publisher = "tlevesque";
      version = "0.7.0";
      sha256 = "0y3l4j57v7a1i3vdg6wxwfkx68pr0ahr02y4cqrvp4w4xy3axwm4";
    }
    {
      name = "vsfire";
      publisher = "toba";
      version = "1.4.1";
      sha256 = "0sdghqqzkfjr29d22v0g6xbv7n5gvmsybcmgnf2zkbl7azvhr4bd";
    }
    {
      name = "theme-alabaster";
      publisher = "tonsky";
      version = "0.2.6";
      sha256 = "1iprimf2dx56gsvl7xb8f4ilfyc72iqgdy05fc83mqvjrkqj0091";
    }
    {
      name = "plastic";
      publisher = "will-stone";
      version = "5.0.0";
      sha256 = "1d7z2df76a8md4l0v0ixyvyr9pi88q1779jqrv5dqxxmifrbvimd";
    }
    {
      name = "vscode-ruby";
      publisher = "wingrunr21";
      version = "0.28.0";
      sha256 = "1gab5cka87zw7i324rz9gmv423rf5sylsq1q1dhfkizmrpwzaxqz";
    }
    {
      name = "vscode-postfix-go";
      publisher = "yokoe";
      version = "0.0.12";
      sha256 = "0risnd3i70wrwcybbb42qrp16pvyac54f7n4zz5mxmdg24wmgrjf";
    }
    {
      name = "markdown-all-in-one";
      publisher = "yzhang";
      version = "3.4.0";
      sha256 = "0ihfrsg2sc8d441a2lkc453zbw1jcpadmmkbkaf42x9b9cipd5qb";
    }
  ] ++ (if pkgs.stdenv.isDarwin then
    [
      {
        name = "vsliveshare";
        publisher = "ms-vsliveshare";
        version = "1.0.3784";
        sha256 = "1fa30acdwm6p8bsnhx5wrypgsb74xfzk8m37xv6i4x3z1wczzcrr";
      }
      {
        name = "vsliveshare-audio";
        publisher = "ms-vsliveshare";
        version = "0.1.91";
        sha256 = "0p00bgn2wmzy9c615h3l3is6yf5cka84il5331z0rkfv2lzh6r7n";
      }
    ] else [ ]));

  finalPackage = (pkgs.vscode-with-extensions.override {
    vscode = latest;
    # https://github.com/NixOS/nixpkgs/pull/110461
    vscodeExtensions = with pkgs.vscode-extensions; (if pkgs.stdenv.isDarwin then [ ] else [ ms-vsliveshare.vsliveshare ]) ++ marketplace;
  }).overrideAttrs (old: {
    inherit (latest) pname version;
  });
in
{
  programs.vscode = {
    enable = true;
    package = finalPackage;
    extensions = [ ];
  };
}
