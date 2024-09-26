# based on https://github.com/informalsystems/cosmos.nix/blob/main/packages/apalache.nix
{
  apalache-repo,
  jre,
  sbt-derivation,
  system
}: let
  version = "v0.46.1 ";

  postPatch = ''
    # Patch the build.sbt file so that it does not call the `git describe` command.
    # This is called by sbt-derivation to resolve the Scala dependencies, however
    # inside the Nix build environment for sbt-derivation, the git command is
    # not available, hence the dependency resolution would fail. As a workaround,
    # we use the version string provided in Nix as the build version.
    substituteInPlace ./build.sbt \
      --replace 'Process("git describe --tags --always").!!.trim' '"${version}"'

    # Patch the wrapper script to use a JRE from the Nix store,
    # and to load the JAR from the Nix store by default.
    substituteInPlace ./src/universal/bin/apalache-mc \
      --replace 'exec java' 'exec ${jre}/bin/java' \
      --replace '$DIR/../lib/apalache.jar' "$out/lib/apalache.jar"
  '';
in
  sbt-derivation.mkSbtDerivation.${system} {
    inherit version postPatch;
    pname = "apalache";

    depsSha256 = "sha256-DZAmca9voNbUhFuZIdO+L6TVPJU/499mBaAhr9cJy20=";
    src = apalache-repo;
    buildPhase = "make dist";
    installPhase = ''
      mkdir $out
      tar \
        --file=target/universal/apalache.tgz \
        --extract \
        --gzip \
        --strip-components=1 \
        --directory=$out
    '';

    overrideDepsAttrs = _: _: {
      inherit postPatch;
    };
  }
