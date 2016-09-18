{ stdenv, lib, fetchurl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "ut-goty-${version}";
  version = "436";

  src = fetchurl {
    name = "unreal.tournament_${version}-multilanguage.goty.run";
    url = "http://liflg.org/?what=dl&catid=6&gameid=51&filename=unreal.tournament_${version}-multilanguage.goty.run";
    sha256 = "0d3dizrydqsng83939mgfqazbwdwjx1d5aqz32pjxh952vr4qw6b";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    sh $src --noexec --target .

    mkdir $out
    for i in data.tar.gz Credits.tar.gz OpenGL_S3TC.ini.tar.gz UT436-OpenGLDrv-Linux-090602.tar.gz; do
      tar -xaf "$i" -C $out
    done

    rm $out/System/lib*

    cp ut.xpm $out
  '';

  meta = with stdenv.lib; {
    description = "A first-person shooter video game developed by Epic Games and Digital Extreme";
    license = licenses.unfree;
    maintainers = with maintainers; [ abbradar ];
  };
}
