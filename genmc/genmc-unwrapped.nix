{
  fetchFromGitHub, 
  stdenv,
  lib,
  autoconf,
  automake,
  llvm_16,
  clang_16,
  libffi,
}:
stdenv.mkDerivation (rec {
  pname = "genmc-unwrapped";
  version = "v0.10.1";
  src = fetchFromGitHub {
    owner = "MPI-SWS";
    repo = "genmc";
    rev = version;
    hash = "sha256-ON1edkoFIHazUFsEo/smyE/wC3JpcnqfH+d9uObtAec=";
  };
  buildInputs = [
    autoconf
    automake
    llvm_16
    clang_16
    libffi
  ];
  buildPhase = ''
    autoreconf --install
    ./configure
    make
  '';
  installPhase = ''
    export libc_includes="${lib.getDev stdenv.cc.libc}/include"
    mkdir -p $out/bin
    cp genmc $out/bin
  '';
})
