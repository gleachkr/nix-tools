{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      out = system:
        let
          pkgs = import nixpkgs { inherit system; overlays = [self.overlays.default]; };
        in
        {
          packages.genmc-unwrapped = pkgs.genmc-unwrapped;

          packages.genmc = pkgs.genmc;

          packages.vampire = pkgs.vampire;

          templates.tlaPlus = ./tlaPlus-template;

          templates.llvm-pass = ./llvm-pass-template;
        };
    in
    flake-utils.lib.eachDefaultSystem out // {

      overlays.default = final: prev: {

        genmc-unwrapped = final.callPackage ./genmc/genmc-unwrapped.nix { };

        genmc = final.callPackage ./genmc/genmc.nix { };

        vampire = final.callPackage ./vampire { };

      };
    };
  }
