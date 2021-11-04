{ stdenv, lib, fetchurl }:

let
  arches = {
    "x86_64-linux" = {
      name = "x86_64";
      ucc-bin = "1c9bw385rqznf7f586kj4fxc5kz1wg0m1ijbdcr31mi9hby8pbm8";
      ut2004-bin = "0w5biiqgv4wa285r0p82lm983f18469bydh91xnsz4zgslb91ql5";
    };
    "i686-linux" = {
      name = "x86";
      ucc-bin = "10bkljg2g0h907jv5snr7mc3wa6ailclymnplv2dpnrcsdfy0l3i";
      ut2004-bin = "1808z3xq2wmnzl07min43hqrn6f7vas4fd0vmibi0g3a0ah5q0yh";
    };
  };

  rev = "4ffc396db3206d8404cc34dad0f70a190d927b21";

  arch = builtins.getAttr stdenv.system arches;

  commonUrl = "https://github.com/liflg/ut2004.megapack-english/raw/${rev}";

  srcs = lib.mapAttrsToList (name: sha256: {
    inherit name;
    src = fetchurl {
      inherit sha256;
      url = "${commonUrl}/bin/Linux/${arch.name}/${name}";
    };
  }) (removeAttrs arch ["name"]);

in stdenv.mkDerivation rec {
  name = "ut2004-patch-${version}";
  version = "3369.2";
  
  src = fetchurl {
    url = "${commonUrl}/ut2004_megapack.tar.bz2";
    sha256 = "1n775bxfavndz3qa44kcp0n1a7hfnnsziixfmrq619hg9fnn5aak";
  };

  buildCommand = ''
    mkdir $out
    tar -xaf $src -C $out
    ${lib.concatMapStringsSep "\n" (bin: ''
      install -Dm755 ${bin.src} $out/System/${bin.name}
    '') srcs}
  '';

  meta = with lib; {
    description = "A first-person shooter video game developed by Epic Games and Digital Extreme";
    homepage = "http://www.unrealtournament2004.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ abbradar ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
