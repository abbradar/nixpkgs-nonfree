self: super: {
  binkplayer = self.callPackage_i686 ./applications/video/binkplayer { };

  nwn = self.callPackage ./games/nwn {
    inherit (self.pkgsi686Linux.xorg) libX11 libXcursor;
    inherit (self.pkgsi686Linux) libelf SDL SDL_gfx mesa_glu;
    stdenv = self.stdenv_32bit;
  };

  ut2004Packages = super.ut2004Packages // {
    ut2004-megapack = self.callPackage ./games/ut2004/megapack.nix { };

    ut2004-gog = self.callPackage ./games/ut2004/gog.nix { };
  };

  ut2004-gog = self.ut2004Packages.ut2004 (with self.ut2004Packages; [ ut2004-gog ut2004-megapack ]);
  ut2004 = self.ut2004Packages.ut2004 (with self.ut2004Packages; [ ut2004-megapack ]);

  SDL_1_1 = self.callPackage ./development/libraries/SDL/1.1.nix { };

  utPackages = {
    ut-goty = self.callPackage ./games/ut/goty.nix { };

    ut-goty-gog = self.callPackage ./games/ut/gog.nix { };

    ut = gamePacks: self.callPackage_i686 ./games/ut/wrapper.nix { inherit gamePacks; };
  };

  ut-gog = self.utPackages.ut (with self.utPackages; [ ut-goty-gog ut-goty ]);
  ut = self.utPackages.ut (with self.utPackages; [ ut-goty ]);

  quake3Packages = {
    quake3-gog = self.callPackage ./games/quake3/gog.nix { };
  };

  quake3-gog = self.quake3wrapper { paks = [ self.quake3Packages.quake3-gog self.quake3pointrelease ]; };
}
