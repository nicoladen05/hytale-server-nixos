{ lib, config, ... }:

{
  options.homelab = {
    enable = lib.mkEnableOption "enable homelab configuration";
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
