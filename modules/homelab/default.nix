{ lib, config, ... }:

{
  imports = [
    ./services
  ];

  options.homelab = {
    enable = lib.mkEnableOption "enable homelab configuration";

    configDir = lib.mkOption {
      type = lib.types.str;
      example = "/mnt/homelab";
      description = "Directory where homelab configuration files are stored.";
    };

    baseDomain = lib.mkOption {
      type = lib.types.str;
      example = "example.com";
      description = "Base domain for homelab services. Should not include https:// or http://.";
    };
  };

  config = lib.mkIf config.homelab.enable {
    virtualisation.containers.enable = true;
    virtualisation.oci-containers.backend = "podman";
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };
  };
}
