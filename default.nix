{ pkgs ? import <nixpkgs> { } }:

let
  callPackage = pkgs.newScope self;

  self = {
    ut2004Packages = {
      ut2004-megapack = callPackage ./games/ut2004/megapack.nix { };

      ut2004-gog = callPackage ./games/ut2004/gog.nix { };
    };

    #ut2004 = pkgs.ut2004Packages.ut2004 (with self.ut2004Packages; [ ut2004-gog ut2004-megapack ]);
    ut2004 = pkgs.ut2004Packages.ut2004 (with self.ut2004Packages; [ ut2004-megapack ]);
  };

in self
