{
  inputs = {
    utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, utils }: utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {

      packages.default = pkgs.stdenv.mkDerivation {
        name = "minimal-llvm-pass";
        src = ./.;
        buildPhase = ''
          cmake 
          make
        '';
        buildInputs = with pkgs; [
          cmake
          llvm
        ];
      };

      packages.test = pkgs.stdenv.mkDerivation {
        name = "minimal-llvm-pass";
        src = ./example;
        buildPhase = ''
          mkdir -p $out/bin
          ${pkgs.clang}/bin/clang -fpass-plugin=${self.packages.${system}.default}/lib/SkeletonPass.so -c example.c
          cc -c handlers.c
          cc handlers.o example.o
          cp a.out $out/bin/testBinary
        '';
      };

      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          clang-tools
          clang
          llvm
        ];
      };

      apps.clang-pass = {
        type = "app";
        program = "${pkgs.writeShellScript "script" ''
          ${pkgs.clang}/bin/clang -fpass-plugin=${self.packages.${system}.default}/lib/SkeletonPass.so "$@"
        ''}";
      };

      apps.test = {
        type = "app";
        program = "${pkgs.writeShellScript "script" ''
          ${self.packages.${system}.test}/bin/testBinary "$@"
        ''}";
      };
    }
  );
}
