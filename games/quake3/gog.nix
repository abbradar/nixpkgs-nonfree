{ stdenv, lib, requireFile, innoextract }:

stdenv.mkDerivation rec {
  name = "quake3-gog-${version}";
  version = "2.0.0.2";

  src = requireFile {
    name = "setup_quake3_${version}.exe";
    url = "https://www.gog.com/game/quake2";
    sha256 ="1mnmyhxs304ghx91s2y6w77sim7dvszg52hsbp7i16pa555inizm";
  };

  buildCommand = ''
    innoextract -e -m $src

    mkdir -p $out
    cp -r app/baseq3 $out
  '';

  nativeBuildInputs = [ innoextract ];

  meta = with lib; {
    license = licenses.unfree;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.all;
  };
}
