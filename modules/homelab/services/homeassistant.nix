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
        type = lib.types.str;
        default = "${config.homelab.configDir}/homeassistant";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.homeassistant = {
      image = "homeassistant/home-assistant:stable";
      autoStart = true;
      volumes = [
        "${cfg.configDir}:/config"
      ];
      priveleged = true;
      environment = {
        TZ = config.system.timeZone;
      };
    };
  };
}
