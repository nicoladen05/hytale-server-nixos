{ config, lib, ... }:

let
  cfg = config.homelab.services.ocis;
in
{
  options.homelab.services.ocis = {
    enable = lib.mkEnableOption "OCIS Cloud";

    url = lib.mkOption {
      type = lib.types.str;
      default = "cloud.${config.homelab.baseDomain}";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 9200;
    };

    configDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.homelab.configDir}/ocis";
    };
  };

  config = lib.mkIf cfg.enable {
    services.ocis = {
      enable = true;
      address = "0.0.0.0";
      url = "https://${cfg.url}";

      stateDir = "/data/ocis";

      inherit (cfg) port configDir;
    };

    networking.firewall.allowedTCPPorts = [ 9200 ];

    services.caddy.virtualHosts."${cfg.url}" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:${builtins.toString cfg.port}
      '';
    };
  };
}
