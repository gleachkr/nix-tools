{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  makeWrapper,
  sail,
}:

buildDunePackage rec {
  pname = "sail_isla_backend";
  version = "0.20.1-unstable-2026-02-25";

  src = fetchFromGitHub {
    owner = "rems-project";
    repo = "isla";
    rev = "7f6882b3f468fe34df38ae3ffc0aede5baa0e7d6";
    hash = "sha256-ilxX8o36PKCeLUWpX3K27TuT9fQUY0x2liPcXXN3NF8=";
  };
  sourceRoot = "${src.name}/isla-sail";

  # Backported from upstream commit 0f0b9da for recent Sail APIs.
  patchFlags = [ "-p2" ];
  patches = [ ./sail-api.patch ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ sail ];

  postInstall = ''
    makeWrapper ${sail}/bin/sail $out/bin/isla-sail \
      --add-flags \
      "--plugin $out/share/libsail/plugins/sail_plugin_isla.cmxs --isla"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    cp -r ../test/property "$TMPDIR/property"
    chmod -R u+w "$TMPDIR/property"
    cd "$TMPDIR/property"
    $out/bin/isla-sail \
      zeros_1.unsat.sail include/config.sail -o smoke
    test -s smoke.ir
    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://github.com/rems-project/isla/tree/master/isla-sail";
    description = "Sail plugin that produces Isla IR";
    license = lib.licenses.bsd2;
    mainProgram = "isla-sail";
    platforms = lib.platforms.unix;
  };
}
