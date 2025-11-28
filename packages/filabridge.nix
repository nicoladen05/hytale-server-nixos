{ buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "filabridge";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "needo37";
    repo = "filabridge";
    rev = "v${version}";
    sha256 = "";
  };
}
