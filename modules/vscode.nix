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
    x86_64-linux = "sha256:1bqyg0996aqbih6f93qqphgfs8lg334hlr2byydz1x7fgyvjsnch";
    x86_64-darwin = "sha256:11rnr41200sbi4rzsxlc0l5fdr0fvpqmz0sfkh8ap1r18g7i89ym";
  }.${system};

  version = "latest";

  latest = (pkgs.vscode.override {
    # Actually true but https://github.com/NixOS/nixpkgs/issues/126272
    isInsiders = false;
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
      version = "2.0.200";
      sha256 = "1qkmkhwjdkzgxbrjmyfdmzvigd5bvbk1m0796bacq9p5rnwm05f7";
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
      version = "0.1.0";
      sha256 = "1y599hmi7ngamvvkwwi9ax4hyzc0hgzp51j52vlrwri6805fwr9y";
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
      version = "1.7.1";
      sha256 = "00la7572zqj8y3y2bgh0ibn3i96xv1yb5k1l8xlb5igac41im5p4";
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
      version = "0.42.0";
      sha256 = "1dr7csq5q18rrz5x790qm4ra17ch2nriqf6zbf6c1k8abqg3jdz1";
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
      version = "2.1.20";
      sha256 = "0xk8pxv5jy89fshda845iswryvmgv0yxr11xsdbvd9zdczqhg7wc";
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
      version = "6.4.0";
      sha256 = "0k5x5d5axbpgyiy6j7q7d2rgxz6mg60sc0qgcca481srnca4j7x4";
    }
    {
      name = "go";
      publisher = "golang";
      version = "0.25.1";
      sha256 = "0v0qxa9w2r50h5iivzyzlbznb8b9a30p1wbfxmxp83kkv4vicdb4";
    }
    {
      name = "vscode-graphql";
      publisher = "GraphQL";
      version = "0.3.16";
      sha256 = "120d5v0qpd1hhhz17xp0pgrmri13gdccz1xhcrn9pvbrxvsvp1il";
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
      version = "8.18.0";
      sha256 = "0krdkma1fr0x07qlifv1qj2qv2isv72i47by5dmkzfsgz2ha98nr";
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
      version = "1.4.7";
      sha256 = "04ghqg4s7g7yylmvbxzwzpnyy4zin2bwlgvflh18m77w4j0ckpiq";
    }
    {
      name = "vscode-styled-components";
      publisher = "jpoissonnier";
      version = "1.6.4";
      sha256 = "10j6zq1by8wi1w0kxm4zbn60a8imvq097lwnc7i440a8lhn3k1gz";
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
      version = "3.4.0";
      sha256 = "0ab7m5jzxakjxaiwmg0jcck53vnn183589bbxh3iiylkpicrv67y";
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
      version = "0.0.6";
      sha256 = "026jknqs955q9jmm4phlidmsv6rn0si0sp5z02kxislnfsc7cnd2";
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
      version = "1.0.11";
      sha256 = "1bk7cj6as1p2g2g3n7wyrgfm995gcjs3si9pj2dxcngjs2gxvv3f";
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
      version = "1.1.19";
      sha256 = "0skzydg68bkwwwfnn2cwybpmv82wmfkbv66f54vl51a0hifv3845";
    }
    {
      name = "python";
      publisher = "ms-python";
      version = "2021.5.842923320";
      sha256 = "183ram995n9dqg7d9g3bn30a1mg7nkkg4knr814f4j9lqzsai22r";
    }
    {
      name = "jupyter";
      publisher = "ms-toolsai";
      version = "2021.6.999201165";
      sha256 = "0wyl1v9wjwbf9wnl93sjiqldy8z0i7dfidcy9arjrszfnw8mmc9f";
    }
    {
      name = "remote-containers";
      publisher = "ms-vscode-remote";
      version = "0.183.0";
      sha256 = "12v7037rn46svv6ff2g824hdkk7l95g4gbzrp5zdddwxs0a62jlg";
    }
    {
      name = "remote-ssh";
      publisher = "ms-vscode-remote";
      version = "0.65.6";
      sha256 = "03a39m3b0ad9fqnbqns3dilxsy1vnv7riadhlxajbcl1afm3s5as";
    }
    {
      name = "remote-ssh-edit";
      publisher = "ms-vscode-remote";
      version = "0.65.6";
      sha256 = "12ml15k0hqw5avhqj1hz3jz0gzkrr56rw85i2igjz4r3qf0wkrav";
    }
    {
      name = "remote-wsl";
      publisher = "ms-vscode-remote";
      version = "0.56.4";
      sha256 = "0cpgb62vaxw75spvb3lyh7v15kbxqz2bghf30hay97d683z95xaw";
    }
    {
      name = "vscode-remote-extensionpack";
      publisher = "ms-vscode-remote";
      version = "0.21.0";
      sha256 = "14l8h84kvnkbqwmw875qa6y25hhxvx1dsg0g07gdl6n8cv5kvy2g";
    }
    {
      name = "vscode-typescript-tslint-plugin";
      publisher = "ms-vscode";
      version = "1.3.3";
      sha256 = "1xjspcmx5p9x8yq1hzjdkq3acq52nilpd9bm069nsvrzzdh0n891";
    }
    {
      name = "vsliveshare-audio";
      publisher = "ms-vsliveshare";
      version = "0.1.91";
      sha256 = "0p00bgn2wmzy9c615h3l3is6yf5cka84il5331z0rkfv2lzh6r7n";
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
      version = "0.24.0";
      sha256 = "1z20hlzwhhi9yzdb8v5iqj7rbf3m5f6xg5p2mc188j85b4gp4jcm";
    }
    {
      name = "language-purescript";
      publisher = "nwolverson";
      version = "0.2.5";
      sha256 = "1ggrpqaa8826rpwflj5cxj0g9r7qnihkcj1z2gg2rsisrhc2k3zf";
    }
    {
      name = "vetur";
      publisher = "octref";
      version = "0.34.1";
      sha256 = "09w3bik1mxs7qac67wgrc58vl98ham3syrn2anycpwd7135wlpby";
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
      version = "0.19.2";
      sha256 = "14rb6r09myakj2amhadnafk8abq4in5q6h4wrnksmzn0b6khk3dl";
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
      version = "1.21.2";
      sha256 = "0b448b72lqrkq6q6ap4dkc16s9ii75gxs5ib9ib3ckazfbz4ag1k";
    }
    {
      name = "sass-indented";
      publisher = "syler";
      version = "1.8.16";
      sha256 = "0fn0bv3lnsfmyhhk99jrcnwr8wzaiam51lrprbaziwgy2z7w64qn";
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
      version = "7.3.0";
      sha256 = "1gb9hpd257czmw8s60bjxadbwdfib7b56mpg82n4iq5bp2claxbj";
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
        version = "1.0.4360";
        sha256 = "0d39b94nxp5brr8ljb5flfn49zms083vp5i7xlrqhz7pskb9dpz8";
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
