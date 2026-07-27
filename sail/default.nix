{
  lib,
  stdenv,
  darwin,
  fetchFromGitHub,
  buildDunePackage,
  base64,
  omd,
  menhir,
  menhirLib,
  ott,
  linenoise,
  dune-site,
  pprint,
  makeWrapper,
  lem,
  linksem,
  yojson,
  z3,
}:

buildDunePackage rec {
  pname = "sail";
  version = "0.20.1-unstable-2026-02-25";

  src = fetchFromGitHub {
    owner = "rems-project";
    repo = "sail";
    rev = "895028208155d9a020b2e66d38dda4faddeea1da";
    hash = "sha256-tGuvCuMnkdcVjpNmzfvyzHIQqO1eh9r14NqEijfaCGA=";
  };

  minimalOCamlVersion = "4.14";

  nativeBuildInputs = [
    makeWrapper
    ott
    menhir
    lem
    z3
  ]
  ++ lib.optionals
    (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64)
    [ darwin.sigtool ];

  propagatedBuildInputs = [
    base64
    omd
    dune-site
    linenoise
    menhirLib
    pprint
    linksem
    yojson
  ];

  preBuild = ''
    # These contain code derived from the non-BSD Arm specification.
    rm -rf aarch64 aarch64_small snapshots
  '';

  # Sail consists of several Dune packages. Building just `pname` omits
  # libraries and backend plugins needed by the main executable.
  buildPhase = ''
    runHook preBuild
    dune build --release ''${enableParallelBuilding:+-j $NIX_BUILD_CORES}
    runHook postBuild
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    dune runtest ''${enableParallelBuilding:+-j $NIX_BUILD_CORES}
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    dune install --prefix $out --libdir $OCAMLFIND_DESTDIR
    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/sail \
      --set SAIL_DIR $out/share/sail \
      --prefix PATH : ${lib.makeBinPath [ z3 ]}
  '';

  meta = {
    homepage = "https://github.com/rems-project/sail";
    description = "Language for describing processor instruction semantics";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
  };
}
