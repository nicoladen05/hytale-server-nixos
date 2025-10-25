{
  lib,
  config,
  network,
  ...
}:

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
    systemd.tmpfiles.rules = [
      "d ${cfg.configDir} 0775 nico users -"
    ];

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
      image = "docker.io/pihole/pihole:latest";
      autoStart = true;
      ports = [
        "${network.clients.server}:53:53/udp"
        "${network.clients.server}:53:53/tcp"
        "${network.clients.server}:8080:80/tcp"
        "${network.clients.server}:8443:443/tcp"
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
