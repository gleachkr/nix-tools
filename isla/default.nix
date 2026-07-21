{
  lib,
  rustPlatform,
  fetchFromGitHub,
  z3,
  makeWrapper,
}:
rustPlatform.buildRustPackage rec {
  pname = "isla";
  version = "0.2.0-unstable-2025-07-21";

  src = fetchFromGitHub {
    owner = "rems-project";
    repo = "isla";
    rev = "7f6882b3f468fe34df38ae3ffc0aede5baa0e7d6";
    hash = "sha256-ilxX8o36PKCeLUWpX3K27TuT9fQUY0x2liPcXXN3NF8=";
  };

  cargoHash = "sha256-9o9EmBVkZylGaOGUbXNZ2UzjQ6RVc4KNZRwUVG1PTvA=";

  nativeBuildInputs = [ makeWrapper ];

  # z3-sys links against libz3 as a shared library.
  buildInputs = [ z3 ];

  # isla-axiomatic shells out to the `z3` binary, so it must be on PATH at
  # runtime. The other binaries link libz3 directly (via RPATH).
  postInstall = ''
    for bin in $out/bin/*; do
      wrapProgram "$bin" --prefix PATH : ${lib.makeBinPath [ z3 ]}
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/rems-project/isla";
    description = "Symbolic execution engine for Sail instruction set architecture specifications";
    license = licenses.bsd2;
    platforms = platforms.unix;
  };
}
