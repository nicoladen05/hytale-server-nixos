{ lib, config, ... }:

let
  cfg = config.homelab.services.n8n;
in
{
  options.homelab.services.n8n = {
    enable = lib.mkEnableOption "Enable Cloudflare DDNS";

    url = lib.mkOption {
      type = lib.types.str;
      default = "n8n.${config.homelab.baseDomain}";
    };
  };

  config = lib.mkIf cfg.enable {
    services.n8n = {
      enable = true;
    };

    services.caddy.virtualHosts."${cfg.url}" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:5678
      '';
    };
  };
}
