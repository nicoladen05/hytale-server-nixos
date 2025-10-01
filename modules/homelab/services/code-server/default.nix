{ lib, config, network, ... }:

let
  cfg = config.homelab.services.homeassistant;
in
{
  options = {
    homelab.services.code-server = {
      enable = lib.mkEnableOption "Enables VSCode Server";

      url = lib.mkOption {
        type = lib.types.str;
        default = "home.${config.homelab.baseDomain}";
      };

      configDir = lib.mkOption {
        type = lib.types.path;
        default = "${config.homelab.configDir}/code-server";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [ "d ${cfg.configDir} 0775 nico users -" ];

    virtualisation.containers.enable = true;
    virtualisation.oci-containers.backend = "podman";
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    virtualisation.oci-containers.containers."code-server" = {
      image = "ghcr.io/linuxserver/code-server:latest";
      autoStart = true;
      volumes = [
        "${builtins.toString cfg.configDir}:/config"
      ];
      environment = {
        TZ = config.system.timeZone;
        PUID = 1000;
        PGID = 1000;
        PROXY_DOMAIN = cfg.url;
      };
      ports = [ "8443:8443" ];
      extraOptions = [ 
        "--dns=${network.clients.router.ip}"
      ];
    };

    networking.firewall.allowedTCPPorts = [ 8443 ];
  };
}
