{
  inputs = {
    utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, utils }: utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      tlaplus18 = pkgs.tlaplus18.overrideAttrs (finalAttrs: prevAttrs: {
        src = pkgs.fetchurl {
          url = "https://github.com/tlaplus/tlaplus/releases/download/v${prevAttrs.version}/tla2tools.jar";
          sha256 = "sha256-+pDDolBkGdmGukP/+LAAta7rexyn8AwzbbTBtphPnHw=";
        };
      });
    in
    {
      devShell = pkgs.mkShell {
        buildInputs = [
          tlaplus18
        ];
      };
    }
  );
}
