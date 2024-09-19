{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
    vim-pandoc = {
      url = "github:vim-pandoc/vim-pandoc";
      flake = false;
    };
    kani-repo = {
        url = "https://github.com/model-checking/kani/archive/refs/tags/kani-0.55.0.tar.gz";
        flake = false;
    };
    kani-tarball = {
        url = "https://github.com/model-checking/kani/releases/download/kani-0.55.0/kani-0.55.0-x86_64-unknown-linux-gnu.tar.gz";
        flake = false;
    };
  };
  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    let
      out = system:
        let
          pkgs = import nixpkgs { 
            inherit system; 
            overlays = [self.overlays.default]; 
          };
        in
        {
          packages.genmc-unwrapped = pkgs.genmc-unwrapped;

          packages.genmc = pkgs.genmc;

          packages.vampire = pkgs.vampire;

          packages.openocd = pkgs.openocd;

          packages.vitejs= pkgs.vitejs;

          packages.neovim = pkgs.my-neovim;

          packages.kani = pkgs.kani;
        };
    in
    flake-utils.lib.eachDefaultSystem out // {

      templates = {

        tlaPlus = {
          description = "a minimal TLA+ template with a modern TLC";
          path = ./tlaPlus-template;
        };

        llvm-pass = {
          description = "A skeleton LLVM pass based on Adrian Sampson's blog";
          path = ./llvm-pass-template;
        };

      };

      overlays.default = final: prev: {

        genmc-unwrapped = final.callPackage ./genmc/genmc-unwrapped.nix { };

        genmc = final.callPackage ./genmc/genmc.nix { };

        vampire = final.callPackage ./vampire { };

        vitejs = final.callPackage ./vitejs { };

        my-neovim = final.callPackage ./neovim { inherit inputs; };

        kani = final.callPackage ./kani { inherit inputs; };

        openocd = prev.openocd.overrideAttrs {
          configureFlags = [
            "--enable-remote-bitbang"
            "--enable-jtag_vpi"
            "--enable-ftd"
          ];
        };

      };
    };
  }
