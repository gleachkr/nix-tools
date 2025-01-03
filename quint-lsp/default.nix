{ buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "quint-lsp";
  version = "0.22.4";
  src = "${fetchFromGitHub {
    owner = "informalsystems";
    repo = "quint";
    rev = "f8b61946216924e4010b4d0b2a963438781f80cd";
    hash = "sha256-evbAg5ihsssGxWIaGAXeebKbyuo91F2yBJAZ4D1nxjk=";
  }}/vscode/quint-vscode/server";

  postPatch = ''
    cp ${./package.json} package.json
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  npmDepsHash = "sha256-c0WFOZ5+jL8YJl2I4rGlK+1PxfF5quGf3qwhoU3kyng=";
}
