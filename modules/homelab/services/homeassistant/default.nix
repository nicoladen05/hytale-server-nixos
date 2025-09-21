{ lib, config, ... }:

let
  cfg = config.homelab.services.homeassistant;
in
{
  options = {
    homelab.services.homeassistant = {
      enable = lib.mkEnableOption "enables homeassistant";

      url = lib.mkOption {
        type = lib.types.str;
        default = "home.${config.homelab.baseDomain}";
      };

      configDir = lib.mkOption {
        type = lib.types.path;
        default = "${config.homelab.configDir}/hass";
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

    virtualisation.oci-containers.containers."homeassistant" = {
      image = "ghcr.io/home-assistant/home-assistant:stable";
      autoStart = true;
      volumes = [
        "${builtins.toString cfg.configDir}:/config"
      ];
      environment = {
        TZ = config.system.timeZone;
      };
      extraOptions = [ "--network=host" ];
    };

    networking.firewall.allowedTCPPorts = [ 8123 ];
  };
}
