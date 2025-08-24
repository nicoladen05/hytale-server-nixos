{
  lib,
  config,
  ...
}:

let
  cfg = config.homelab.services.windows;
in
{
  options = {
    homelab.services.windows = {
      enable = lib.mkEnableOption "enables minecraft docker container";

      version = lib.mkOption {
        type = lib.types.string;
        example = "1.21.1";
      };

      type = lib.mkOption {
        type = lib.types.string;
        example = "FABRIC";
      };

      packwizUrl = lib.mkOption {
        type = lib.types.string;
        default = "";
      };

      memory = lib.mkOption {
        type = lib.types.string;
        default = "4G";
      };

      configDir = lib.mkOption {
        type = lib.types.str;
        default = "${config.homelab.configDir}/minecraft";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    netowrking.firewall.allowedTCPPorts = [ 25565 ];

    virtualisation.oci-containers.containers."minecraft" = {
      image = "itzg/minecraft-server";
      autoStart = true;
      ports = [
        "25565:25565"
      ];
      volumes = [
        "${cfg.configDir}:/data"
      ];
      environment = {
        EULA = cfg.eula;
        VERSION = cfg.version;
        TYPE = cfg.type;
        PACKWIZ_URL = cfg.packwizUrl;
        MEMORY = cfg.memory;
        USE_MEOWICE_FLAGS = true;
      };
    };
  };
}
