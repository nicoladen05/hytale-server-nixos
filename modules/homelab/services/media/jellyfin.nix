{ lib, config, ... }:

let
  cfg = config.homelab.services.media.jellyfin;
  media = config.homelab.services.media;
in
{
  options.homelab.services.media.jellyfin = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = media.enable;
      example = false;
    };
  };

  config = lib.mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
      group = "users";
    };
  };
}
