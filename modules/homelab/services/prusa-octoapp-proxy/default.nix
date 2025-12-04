{ lib, config, ... }:

let
  cfg = config.homelab.services.prusa-octoapp-proxy;
in
{
  options.homelab.services.prusa-octoapp-proxy = {
    enable = lib.mkEnableOption "prusa-octoapp-proxy";
    port = lib.mkOption {
      type = lib.types.port;
      default = 8000;
      description = "The port on which the Prusa OctoApp Proxy should listen.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.prusa-octoapp-proxy = {
      enable = true;
      inherit (cfg) port;
      openFirewall = true;
    };
  };
}
