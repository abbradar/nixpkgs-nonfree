{ stdenv, requireFile, innoextract }:

stdenv.mkDerivation rec {
  name = "ut2004-gog-${version}";
  version = "2.0.0.6";

  gogSetup = requireFile {
    name = "setup_ut2004_${version}.exe";
    url = "https://www.gog.com/game/unreal_tournament_2004_ece";
    sha256 = "1hgj7v8a1rcs8lx6blcj7d0q8c2ksawyxf12wkr2hqnfrgdirklj";
  };

  gogData1 = requireFile {
    name = "setup_ut2004_${version}-1.bin";
    url = "https://www.gog.com/game/unreal_tournament_2004_ece";
    sha256 = "1wqwvdagrq201x1rfq6xccpn11cgmwzidrcs1b0bif8c0nziwdrh";
  };

  gogData2 = requireFile {
    name = "setup_ut2004_${version}-2.bin";
    url = "https://www.gog.com/game/unreal_tournament_2004_ece";
    sha256 = "1llg82smq23bmchlslq79b0n756ml9yc60am86p4z00f6qa35lmq";
  };

  buildCommand = ''
    ln -s $gogSetup setup.exe
    ln -s $gogData1 setup-1.bin
    ln -s $gogData2 setup-2.bin
    innoextract -e -m setup.exe

    mkdir $out
    cp -r app/* $out
    rm app/System/*.{exe,dll}
  '';

  nativeBuildInputs = [ innoextract ];

  meta = with stdenv.lib; {
    description = "A first-person shooter video game developed by Epic Games and Digital Extreme -- GOG version";
    homepage = "http://www.unrealtournament2004.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.all;
  };
}
