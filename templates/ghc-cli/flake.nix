{
  description = "A native Haskell command-line starter";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs =
    { nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
    in
    {
      devShells = lib.genAttrs systems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          hs = pkgs.haskellPackages;
          starterLibraries = p: [ p.megaparsec ];

          # Nixpkgs' HLS wrapper targets its default GHC, the same one used here.
          mkDevShell =
            ghc:
            pkgs.mkShell {
              packages = [
                ghc
                pkgs.cabal-install
                pkgs.haskell-language-server
                pkgs.ripgrep
                pkgs.fd
              ];
            };
        in
        {
          default = mkDevShell (hs.ghcWithPackages starterLibraries);
          hoogle = mkDevShell (hs.ghcWithHoogle starterLibraries);
        }
      );
    };
}
