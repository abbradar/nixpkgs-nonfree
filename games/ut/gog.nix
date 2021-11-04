{ stdenv, lib, requireFile, innoextract }:

stdenv.mkDerivation rec {
  name = "ut-goty-gog-${version}";
  version = "2.0.0.5";

  src = requireFile {
    name = "setup_ut_goty_${version}.exe";
    url = "https://www.gog.com/game/unreal_tournament_goty";
    sha256 = "00v8jbqhgb1fry7jvr0i3mb5jscc19niigzjc989qrcp9pamghjc";
  };

  buildCommand = ''
    innoextract -e -m $src

    mkdir $out
    cp -r app/* $out
    find $out \( -name \*.dll -o -name \*.exe \) -delete
  '';

  nativeBuildInputs = [ innoextract ];

  meta = with lib; {
    description = "A first-person shooter video game developed by Epic Games and Digital Extreme -- GOG GOTY version";
    license = licenses.unfree;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.all;
  };
}
