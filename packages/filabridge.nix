{ buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "filabridge";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "needo37";
    repo = "filabridge";
    rev = "v${version}";
    hash = "sha256-ayYsiWUkMUiO+TLF+WTcgpfu2VCKAXjxgZzxGqSB1Wo=";
  };

  vendorHash = "sha256-P3Dp5AUW6ysOd3YktZgCIzY688vevbIVYNe5S9ie5bc=";
}
