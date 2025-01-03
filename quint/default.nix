{ buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "quint";
  version = "0.22.4";
  src = "${fetchFromGitHub {
    owner = "informalsystems";
    repo = "quint";
    rev = "f8b61946216924e4010b4d0b2a963438781f80cd";
    hash = "sha256-evbAg5ihsssGxWIaGAXeebKbyuo91F2yBJAZ4D1nxjk=";
  }}/quint";

  dontNpmBuild = true;

  npmDepsHash = "sha256-xWHHSSU0YuEVZ+ez8VRV0bqZy3amb8e4011VPYBLQz0=";
}
