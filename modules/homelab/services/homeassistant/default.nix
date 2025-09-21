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
    virtualisation.oci-containers."homeassistant" = {
      name = "homeassistant";
      image = "ghcr.io/homeassistant/home-assistant:stable";
      autoStart = true;
      volumes = [
        "${builtins.toString cfg.configDir}:/config"
      ];
      privileged = true;
      environment = {
        TZ = config.system.timeZone;
      };
    };

    networking.firewall.allowedTCPPorts = [ 8123 ];
  };
}
