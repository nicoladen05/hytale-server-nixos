{ lib, config, ... }:

let
  cfg = config.homelab.services.immich;
in
{
  options.homelab.services.immich = {
    enable = lib.mkEnableOption "Enable Immich";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "";
    };

    hardwareAcceleration = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    mediaLocation = lib.mkOption {
      type = lib.types.str;
      default = "/opt/services/immich";
    };
  };

  config = lib.mkIf cfg.enable {
    services.immich = {
      enable = true;
      accelerationDevices = lib.mkIf cfg.hardwareAcceleration [ "/dev/dri/renderD128" ];
      mediaLocation = cfg.mediaLocation;
      openFirewall = true;
      port = 2283;
      host = "192.168.2.53";
      settings.server.externalDomain = cfg.domain;
    };
  };
}
