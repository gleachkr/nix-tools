{
  stdenv,
  nodejs,
  pnpm_9,
  fetchFromGitHub,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vitejs";
  version = "5.4.2";

  src = fetchFromGitHub {
    owner = "vitejs";
    repo = "vite";
    rev = "v5.4.2";
    sha256 = "sha256-UuNcquNv5PSW1OCxiGr0FBbJYPx8SXK7a6xgXDGcz2g=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9.configHook
    makeWrapper
  ];

  buildPhase = ''
  npm run build
  '';

  installPhase = ''
  mkdir -p $out/lib
  mkdir -p $out/bin
  mv node_modules $out/lib/node_modules
  mv packages $out/lib/packages
  makeWrapper $out/lib/node_modules/.bin/vite $out/bin/vite
  '';

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-7Tfbh3PW0jdA1W+f62wIkwBS1scDY55+bVH2lePVEcg=";
  };
})
