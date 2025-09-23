{ lib, config, ... }:

let
  cfg = config.homelab.services.n8n;
in
{
  options.homelab.services.n8n = {
    enable = lib.mkEnableOption "Enable Cloudflare DDNS";
  };

  config = lib.mkIf cfg.enable {
    services.n8n = {
      enable = true;
      openFirewall = true;
    };
  };
}
