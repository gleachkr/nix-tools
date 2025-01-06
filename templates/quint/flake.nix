{
  inputs = {
    utils.url = "github:numtide/flake-utils";
    nix-tools.url = "github:gleachkr/nix-tools";
  };
  outputs = { self, nixpkgs, utils, nix-tools }: utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      toolPkgs = nix-tools.packages.${system};
    in
    {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          toolPkgs.quint
          toolPkgs.quint-lsp
          #NOTE: To use quint verify, start the apalache server first, using `apalache-mc server`
          toolPkgs.apalache
        ];
      };
    }
  );
}
