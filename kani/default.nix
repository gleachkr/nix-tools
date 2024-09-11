{ inputs, glibc, extend, rsync, makeWrapper, stdenv, autoPatchelfHook }:
let
  rustPkgs = extend (import inputs.rust-overlay);

  rustHome = rustPkgs.rust-bin.nightly."2024-09-03".default.override {
    extensions = ["rustc-dev" "rust-src" "llvm-tools" "rustfmt"];
  };

  rustPlatform = rustPkgs.makeRustPlatform {
    cargo = rustHome;
    rustc = rustHome;
  };

  kani-home = stdenv.mkDerivation {
    name = "kani-home";

    src = inputs.kani-tarball;

    buildInputs = [
      stdenv.cc.cc.lib #libs needed by patchelf
    ];

    runtimeDependencies = [
      glibc #not detected as missing by patchelf for some reason
    ];

    nativeBuildInputs = [ autoPatchelfHook ];

    installPhase = ''
      runHook preInstall
      ${rsync}/bin/rsync -av $src/ $out --exclude kani-compiler
      runHook postInstall
    '';
  };

in rustPlatform.buildRustPackage rec {
  pname = "kani";

  version = "kani-0.55.0";

  src = inputs.kani-repo;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    mkdir -p $out/lib/
    ${rsync}/bin/rsync -av ${kani-home}/ $out/lib/${version} --perms --chmod=D+rw,F+rw
    cp $out/bin/* $out/lib/${version}/bin/
    ln -s ${rustHome} $out/lib/${version}/toolchain
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
