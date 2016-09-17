{ stdenv, lib, fetchurl }:

let
  arch =
    if stdenv.system == "x86_64-linux" then "x86_64"
    else if stdenv.system == "i686-linux" then "x86"
    else throw "Unsupported architecture";

in stdenv.mkDerivation rec {
  name = "ut2004-patch-${version}";
  version = "3369.2";

  src = fetchurl {
    name = "ut2004.megapack-english-3.run";
    url = "http://www.liflg.org/?what=dl&catid=6&gameid=17&filename=ut2004.megapack-english-3.run";
    sha256 = "0fxx2dlz11hfpdhwfdwhk7ix365k8mfrsf40q1njzma3zfmkygad";
  };

  buildCommand = ''
    sh $src --noexec --target .

    mkdir $out
    tar -xaf ut2004_megapack.tar.bz2 -C $out
    cp -r bin/Linux/${arch}/* $out/System
  '';

  meta = with stdenv.lib; {
    description = "A first-person shooter video game developed by Epic Games and Digital Extreme";
    homepage = "http://www.unrealtournament2004.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ abbradar ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
