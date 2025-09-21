{ lib, config, ... }:

{
  imports = [
    ./services
  ];

  options.homelab = {
    enable = lib.mkEnableOption "enable homelab configuration";

    external = lib.mkEnableOption "enable external access (forward port 80 and 443)";

    configDir = lib.mkOption {
      type = lib.types.str;
      default = "/opt/services";
      description = "Directory where homelab configuration files are stored.";
    };

    baseDomain = lib.mkOption {
      type = lib.types.str;
      example = "example.com";
      description = "Base domain for homelab services. Should not include https:// or http://.";
    };
  };
}
