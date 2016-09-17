{ pkgs ? import <nixpkgs> { } }:

let
  inherit (pkgs) pkgsi686Linux callPackage_i686;

  self = {
    callPackage = pkgs.newScope self;

    binkplayer = callPackage_i686 ./applications/video/binkplayer { };

    nwn = self.callPackage ./games/nwn {
      inherit (pkgsi686Linux.xlibs) libX11 libXcursor;
      inherit (pkgsi686Linux) libelf SDL SDL_gfx mesa_glu;
      stdenv = pkgs.stdenv_32bit;
    };

    ut2004Packages = {
      ut2004-megapack = self.callPackage ./games/ut2004/megapack.nix { };

      ut2004-gog = self.callPackage ./games/ut2004/gog.nix { };
    };

    #ut2004 = pkgs.ut2004Packages.ut2004 (with self.ut2004Packages; [ ut2004-gog ut2004-megapack ]);
    ut2004 = pkgs.ut2004Packages.ut2004 (with self.ut2004Packages; [ ut2004-megapack ]);
  };

in self
