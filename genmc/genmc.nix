{
  stdenv,
  genmc-unwrapped,
  lib,
  llvm_16,
  clang_16,
  libffi,
  glibc,
}:
stdenv.mkDerivation {
  unwrapped = genmc-unwrapped;
  version = lib.getVersion genmc-unwrapped;
  clang = clang_16;
  pname = "genmc";
  dontUnpack = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    substituteAll ${./wrapper} $out/bin/genmc
    chmod +x $out/bin/genmc
    runHook postInstall
  '';
  buildInputs = [
    llvm_16
    clang_16
    libffi
    glibc
  ];
}
