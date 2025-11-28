{ lib, config, ... }:

let
  cfg = config.homelab.services.spoolman;
in
{
  imports = [
    ./filabridge.nix
  ];

  options.homelab.services.spoolman = {
    enable = lib.mkEnableOption "spoolman";
    port = lib.mkOption {
      type = lib.types.int;
      default = 7912;
      description = "The port on which spoolman will listen.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.spoolman = {
      enable = true;
      listen = "0.0.0.0";
      inherit (cfg) port;
      openFirewall = true;
    };
  };
}
