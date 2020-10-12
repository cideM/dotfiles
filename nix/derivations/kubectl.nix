# kubectl version that is compatible with our Kubernetes cluster at work
{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "kubectl-${version}";

  version = "1.15";

  src = fetchurl {
    url = "https://amazon-eks.s3.us-west-2.amazonaws.com/1.15.11/2020-08-04/bin/linux/amd64/kubectl";
    sha256 = "1knchnf6bh68lx12zpz2jjjd81zgm02jrcbxpzs71dniwasdghqc";
  };

  sourceRoot = ".";

  dontBuild = true;
  dontConfigure = true;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/kubectl
    chmod +x $out/bin/kubectl
  '';
}
