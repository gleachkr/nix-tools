{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
    sbt-derivation.url = "github:zaninime/sbt-derivation";
    alectryon-repo = {
      url = "github:cpitclaudel/alectryon";
      flake = false;
    };
    leanink-repo = {
      url = "github:leanprover/leanink";
      flake = false;
    };
    kani-repo = {
      url = "git+https://github.com/model-checking/kani?ref=main&rev=96f7e59a8c8058f3edbdcc4d52940e376d54ff09&submodules=1";
      flake = false;
    };
    kani-tarball = {
      url = "https://github.com/model-checking/kani/releases/download/kani-0.64.0/kani-0.64.0-x86_64-unknown-linux-gnu.tar.gz";
      flake = false;
    };
    apalache-repo = {
      url = "github:apalache-mc/apalache/v0.46.1"; # NOTE: also available via cosmos.nix, but this is a more recent version
      flake = false;
    };
    ebmc-repo = {
      url = "git+https://github.com/diffblue/hw-cbmc.git?submodules=1";
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

      packages.kani = pkgs.kani;

      packages.quint = pkgs.quint;

      packages.souffle = pkgs.souffle;

      packages.quint-lsp = pkgs.quint-lsp;

      packages.apalache = pkgs.apalache;

      packages.ebmc = pkgs.ebmc;

      packages.alectryon = pkgs.alectryon;

    };

  in
  flake-utils.lib.eachDefaultSystem out // {

      # templates and overlays go here because they don't need a <system>
      # version being added by flake-utils 

      templates = {

        tlaPlus = {
          description = "a minimal TLA+ template with a modern TLC";
          path = ./templates/tlaPlus;
        };

        llvm-pass = {
          description = "A skeleton LLVM pass based on Adrian Sampson's blog";
          path = ./templates/llvm-pass;
        };

        ghc-wasm = {
          description = "a minimal template GHC WASM project";
          path = ./templates/ghc-wasm;
        };
      };

      overlays.default = final: prev: {

        genmc-unwrapped = final.callPackage ./genmc/genmc-unwrapped.nix { };

        genmc = final.callPackage ./genmc/genmc.nix { };

        vampire = final.callPackage ./vampire { };

        vitejs = final.callPackage ./vitejs { };

        quint = final.callPackage ./quint { };

        souffle = final.callPackage ./souffle { };

        quint-lsp = final.callPackage ./quint-lsp { };

        alectryon = final.python312Packages.callPackage ./alectryon { 
          inherit (inputs) leanink-repo alectryon-repo; 
        };

        ebmc = final.callPackage ./ebmc { inherit (inputs) ebmc-repo; };

        kani = final.callPackage ./kani { 
          inherit (inputs) rust-overlay kani-tarball kani-repo; 
        };

        apalache = final.callPackage ./apalache { 
          inherit (inputs) apalache-repo sbt-derivation; 
        };

        openocd = prev.openocd.overrideAttrs {
          configureFlags = [
            "--enable-remote-bitbang"
            "--enable-jtag_vpi"
            "--enable-ftd"
            "--disable-werror" 
            # ↑ this is necessary because of warning related to a calloc call
            # with transposed arguments. calloc(a,sizeof(b)) is equivalent to
            # calloc(sizeof(b),a), but the sizeof is technically upposed to go
            # in the second argument.
          ];
        };

      };
    };
  }
