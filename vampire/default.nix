{
  stdenv,
  fetchFromGitHub,
  z3,
  zlib,
  lib,
}:
stdenv.mkDerivation {
  pname = "vampire";
  version = "4.8-dev";

  src = fetchFromGitHub {
    owner = "vprover";
    repo = "vampire";
    rev = "23d7e9c3b61479bc14e1687f917c22f80dc7c8f1";
    sha256 = "sha256-Aig86q+f+XvQCqJyHqR610+4+mzy+gwAxY6lSdRAvss=";
  };

  buildInputs = [ z3 zlib ];

  makeFlags = [ "vampire_z3_rel" "CC:=$(CC)" "CXX:=$(CXX)" ];

  enableParallelBuilding = true;

  fixupPhase = ''
    rm -rf z3
  '';

  installPhase = ''
    install -m0755 -D vampire_z3_rel* $out/bin/vampire
  '';

  meta = with lib; {
    homepage = "https://vprover.github.io/";
    description = "The Vampire Theorem Prover";
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
}
