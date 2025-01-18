{ 
  leanink-repo,
  alectryon-repo,
  lean4,
  lib,
  stdenv,
  symlinkJoin,
  buildPythonPackage,
  fetchFromGithub,
  pygments,
  dominate,
  beautifulsoup4,
  docutils,
  sphinx,
} : let
  leanink = stdenv.mkDerivation {
    name = "leanink";
    src = leanink-repo;
    buildPhase = ''
      lake build
      mkdir -p $out/bin
      cp .lake/build/bin/* $out/bin
    '';
    buildInputs = [ lean4 ];
  };

  alectryon = buildPythonPackage {
    pname = "alectryon";
    version = "1.4.0";
    format = "setuptools";

    src = alectryon-repo;

    propagatedBuildInputs = [
      pygments
      dominate
      beautifulsoup4
      docutils
      sphinx
    ];

    doCheck = false;

    meta = with lib; {
      homepage = "https://github.com/cpitclaudel/alectryon";
      description = "Collection of tools for writing technical documents that mix Coq code and prose";
      mainProgram = "alectryon";
      license = licenses.mit;
    };
  }; in symlinkJoin {
    name = "alectryon-lean";
    paths = [ alectryon leanink ];
  }
