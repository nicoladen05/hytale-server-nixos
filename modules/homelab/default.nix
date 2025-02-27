{ lib, config, ... }:

{
  options.homelab = {
    enable = lib.mkEnableOption "enable homelab configuration";
  };

  config = lib.mkIf config.homelab.enable {
    virtualization.containers.enable = true;
    virtualization.oci-containers.backend = "podman";
    virtualization = {
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };
  };
}
