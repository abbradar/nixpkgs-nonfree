{ stdenv, lib, runCommand, buildEnv, makeWrapper, makeDesktopItem, gamePacks, SDL_1_1, libpulseaudio }:

let
  libPath = lib.makeLibraryPath [ SDL_1_1 ];

  game = buildEnv {
    name = "ut-game";
    paths = gamePacks;
    ignoreCollisions = true;
    pathsToLink = [ "/" "/System" ];
    postBuild = ''
      for i in $out/System/*-bin; do
        path="$(readlink -f "$i")"
        rm "$i"
        cp "$path" "$i"
        chmod +w "$i"
        patchelf \
          --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) \
          "$i"
      done
    '';
  };

  desktop = makeDesktopItem {
    name = "ut";
    desktopName = "Unreal Tournament";
    comment = "A first-person shooter video game developed by Epic Games and Digital Extreme";
    genericName = "First-person shooter";
    categories = "Application;Game;";
    exec = "ut";
  };

in runCommand "ut" {
  nativeBuildInputs = [ makeWrapper ];
} ''
  mkdir -p $out/bin

  # patchelf breaks Core.so
  for i in ${game}/System/*-bin; do
    name="$(basename "$i")"
    makeWrapper "$i" "$out/bin/$name" \
      --run "cd ${game}/System" \
      --prefix LD_LIBRARY_PATH : ${libPath} \
      --prefix LD_PRELOAD : ${libpulseaudio}/lib/pulseaudio/libpulsedsp.so
  done

  mkdir -p $out/share/applications $out/share/icons/hicolor/48x48/apps
  ln -s ${desktop}/share/applications/* $out/share/applications
  ln -s ${game}/ut.xpm $out/share/icons/hicolor/48x48/apps
''
