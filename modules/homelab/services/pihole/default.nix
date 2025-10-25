{ lib, config, ... }:

let
  cfg = config.homelab.services.pihole;
in
{
  options.homelab.services.pihole = {
    enable = lib.mkEnableOption "Enable Pihole";
    configDir = lib.mkOption {
      type = lib.types.path;
      default = "${config.homelab.configDir}/pihole";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.containers.enable = true;
    virtualisation.oci-containers.backend = "podman";
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = false;
      };
    };

    virtualisation.oci-containers.containers."pihole" = {
      image = "ghcr.io/pihole/pihole:latest";
      autoStart = true;
      ports = [
        "53:53/udp"
        "53:53/tcp"
        "8080:80/tcp"
        "8443:443/tcp"
      ];
      volumes = [
        "${builtins.toString cfg.configDir}:/etc/pihole"
      ];
      environment = {
        TZ = config.system.timeZone;
        FTLCONF_webserver_api_password = "correct horse battery staple";
        FTLCONF_dns_listeningMode = "all";
      };
    };

    networking.firewall.allowedTCPPorts = [
      53
      8080
      8443
    ];

  };
}
