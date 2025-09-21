{ lib, config, ... }:

let
  cfg = config.homelab.services.media.sabnzbd;
  media = config.homelab.services.media;
in
{
  options.homelab.services.media.sabnzbd = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = media.enable;
      example = false;
    };
  };

  config = lib.mkIf cfg.enable {
    services.sabnzbd = {
      enable = true;
      openFirewall = true;
      group = "users";
    };
  };
}
