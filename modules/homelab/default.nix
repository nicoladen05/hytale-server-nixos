{ lib, config, ... }:

{
  options.homelab = {
    enable = lib.mkEnableOption "enable homelab configuration";

    configDir = lib.mkOption {
      type = lib.types.str;
      example = "/mnt/homelab";
    };

    baseDomain = lib.mkOption {
      type = lib.types.str;
      example = "example.com";
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
