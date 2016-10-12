{ stdenv, requireFile, p7zip, SDL, openalSoft }:

let
  deps = stdenv.lib.makeLibraryPath [ SDL openalSoft ];

in stdenv.mkDerivation {
  name = "BinkPlayer";

  src = requireFile {
    url = "http://www.radgametools.com/down/Bink/BinkLinuxPlayer.7z";
    name = "BinkLinuxPlayer.7z";
    sha256 = "1dqr36v9l3hk4w6k4x7dzv1w6p9x0v27b0s30sl0i47frfyww7cr";
  };

  buildCommand = ''
    mkdir -p $out/bin
    cd $out/bin
    7z x $src
    chmod +x BinkPlayer
    patchelf \
      --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) \
      --set-rpath ${deps} \
      BinkPlayer
  '';

  nativeBuildInputs = [ p7zip ];

  meta = with stdenv.lib; {
    description = "Play Bink files (or compiled Bink EXE files) from the command line";
    homepage = "http://www.radgametools.com/bnkmain.htm";
    license = licenses.unfree;
    platforms = [ "i686-linux" ];
    maintainers = with maintainers; [ abbradar ];
  };
}
