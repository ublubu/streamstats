{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, stdenv, vector, random
      , cabal-install, alex, happy, ghc-mod, hlint, stylish-haskell, hasktags
      }:
      mkDerivation {
        pname = "streamstats";
        version = "0.1.0.0";
        src = ./.;
        isLibrary = false;
        isExecutable = true;
        executableHaskellDepends = [ base vector random ];
        buildTools = [cabal-install alex happy ghc-mod hlint stylish-haskell hasktags];
        homepage = "https://github.com/ublubu/streamstats";
        description = "streaming statistics";
        license = stdenv.lib.licenses.unfree;
      };

  haskellPackages = if compiler == "default"
                      then pkgs.haskellPackages
                      else pkgs.haskell.packages.${compiler};

  drv = haskellPackages.callPackage f {};

in

  if pkgs.lib.inNixShell then drv.env else drv
