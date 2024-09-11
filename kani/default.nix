{ inputs, pkgs, makeWrapper }:
let
  rustPkgs = pkgs.extend (import inputs.rust-overlay);

  rustHome = rustPkgs.rust-bin.nightly."2024-09-03".default.override {
    extensions = ["rustc-dev" "rust-src" "llvm-tools" "rustfmt"];
  };

  rustPlatform = pkgs.makeRustPlatform {
    cargo = rustHome;
    rustc = rustHome;
  };

in rustPlatform.buildRustPackage rec {
  pname = "kani";

  version = "kani-0.55.0";

  src = inputs.kani-repo;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    mkdir -p $out/lib/
    ${pkgs.rsync}/bin/rsync -av ${inputs.kani-tarball}/ $out/lib/${version} --perms --chmod=D+rw,F+rw
    cp $out/bin/* $out/lib/${version}/bin/
  '';

  postFixup = ''
    wrapProgram $out/bin/kani --set KANI_HOME $out/lib/
    wrapProgram $out/bin/cargo-kani --set KANI_HOME $out/lib/
  '';


  cargoHash = "sha256-B7vMvPdIrETCONVf1OQa4TQqjV8vQTPPQD+PKh7Vi3M=";

  env = {
    RUSTUP_HOME = "${rustHome}";
    RUSTUP_TOOLCHAIN = "..";
  };
}
