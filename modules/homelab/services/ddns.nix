{ lib, config, ... }:

let
  cfg = config.homelab.services.ddns;
in
{
  options.homelab.services.ddns = {
    enable = lib.mkEnableOption "Enable Cloudflare DDNS";

    tokenFile = lib.mkOption {
      type = lib.types.path;
      example = "/etc/cloudflare-dyndns-token";
    };

    domains = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ 
        "ddns.${config.homelab.baseDomain}" 
        "*.${config.homelab.baseDomain}" 
      ];
    };

  };

  config = lib.mkIf cfg.enable {
    services.cloudflare-dyndns = {
      enable = true;
      apiTokenFile = cfg.tokenFile;
      inherit (cfg) domains;

      ipv4 = true;
      ipv6 = true;
    };
  };
}
