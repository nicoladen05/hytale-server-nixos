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
    # Create mediaLocation if it does not exist and set permission
    systemd.tmpfiles.rules = [ 
      "d ${cfg.mediaLocation} 0755 immich immich -" 
    ];

    # Immich config
    services.immich = {
      enable = true;
      accelerationDevices = lib.mkIf cfg.hardwareAcceleration [ "/dev/dri/renderD128" ];
      mediaLocation = cfg.mediaLocation;
      openFirewall = true;
      host = "0.0.0.0";
      port = 2283;
      settings.server.externalDomain = cfg.domain;
    };

    networking.firewall.allowedTCPPorts = [ 2283 ];
  };
}
