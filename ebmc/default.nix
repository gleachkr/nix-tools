{ flex, bison, zlib, curl, ebmc-repo, stdenv } :
let
  ebmc-with-minisat = stdenv.mkDerivation {
    name = "ebmc-with-minisat";
    src = ebmc-repo;
    buildPhase = '' make -C lib/cbmc/src minisat2-download '';
    installPhase = ''mkdir $out; cp -r * $out'';
    nativeBuildInputs = [ curl ];
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-R4U7lTzkqrKVzgg8qeSXlLSzxV0aJvJ0hCsonxRwDfY=";
    dontFixup = true;
  };
in stdenv.mkDerivation {
  name = "ebmc";

  src = ebmc-with-minisat;

  buildPhase = ''make -C src'';

  installPhase = ''
  mkdir -p $out/bin
  cp src/ebmc/ebmc $out/bin
  '';

  buildInputs =  [ zlib ];

  nativeBuildInputs = [ flex bison ];
}
