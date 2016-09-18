{ nixpkgs ? import <nixpkgs> { } }:

let
  pkgset = pkgs: let
    inherit (nixpkgs) lib;

    core = self: {
      callPackage = pkgs.newScope self;

      callPackage_i686 = result_i686.callPackage;

      binkplayer = self.callPackage_i686 ./applications/video/binkplayer { };

      nwn = self.callPackage ./games/nwn {
        inherit (pkgs.pkgsi686Linux.xorg) libX11 libXcursor;
        inherit (pkgs.pkgsi686Linux) libelf SDL SDL_gfx mesa_glu;
        stdenv = pkgs.stdenv_32bit;
      };

      ut2004Packages = pkgs.ut2004Packages // {
        ut2004-megapack = self.callPackage ./games/ut2004/megapack.nix { };

        ut2004-gog = self.callPackage ./games/ut2004/gog.nix { };
      };

      ut2004-gog = self.ut2004Packages.ut2004 (with self.ut2004Packages; [ ut2004-gog ut2004-megapack ]);
      ut2004 = self.ut2004Packages.ut2004 (with self.ut2004Packages; [ ut2004-megapack ]);

      SDL_1_1 = self.callPackage ./development/libraries/SDL/1.1.nix { };

      utPackages = {
        ut-goty = self.callPackage ./games/ut/goty.nix { };

        ut = gamePacks: self.callPackage_i686 ./games/ut/wrapper.nix { inherit gamePacks; };
      };

      ut = self.utPackages.ut (with self.utPackages; [ ut-goty ]);
    };

    result = lib.fix core;

    result_i686 = pkgset pkgs.pkgsi686Linux;
  in result;

in pkgset nixpkgs
