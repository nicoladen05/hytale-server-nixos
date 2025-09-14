{ lib, config, ... }:

let
  cfg = config.homelab.services.homeassistant;
  mkContainer = (import ../../helpers/container.nix { inherit lib; });
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

  config = lib.mkIf cfg.enable (
    mkContainer {
      name = "homeassistant";
      image = "ghcr.io/homeassistant/home-assistant:stable";
      autoStart = true;
      volumes = [
        "${cfg.configDir}:/config"
      ];
      privileged = true;
      environment = {
        TZ = config.system.timeZone;
      };
    }
  );
}
