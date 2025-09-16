{ lib, config, ... }:

let
  cfg = config.homelab.services.pihole;
in
{
  options.homelab.services.pihole = {
    enable = lib.mkEnableOption "Enable Pihole";
    lists = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [];
    };
  };
}
