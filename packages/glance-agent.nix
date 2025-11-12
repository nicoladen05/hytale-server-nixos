{ buildGoPackage, ... }:

buildGoPackage rec {
  pname = "glance-agent";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "glanceapp";
    repo = "agent";
    rev = "v${version}";
    hash = "sha256-eNhOelHR3EB3RWWMe7fG6vklgADX7XFy6QMI4Lfr8oM=";
  };

  vendorHash = lib.fakeSha256;
}
