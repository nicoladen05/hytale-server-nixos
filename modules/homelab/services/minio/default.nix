{ lib, config, ... }:

let
  cfg = config.homelab.services.minio;
in
{
  options.homelab.services.minio = {
    enable = lib.mkEnableOption "Enable minio";
    configDir = lib.mkOption {
      type = lib.types.path;
      default = "${config.homelab.configDir}/minio";
      description = "Path to the minio configuration directory";
    };
    url = lib.mkOption {
      type = lib.types.str;
      default = "minio.${config.homelab.baseDomain}";
      description = "URL of the minio service";
    };
  };

  config = lib.mkIf cfg.enable {
    services.minio = {
      enable = true;

      inherit (cfg) configDir;
    };

    networking.firewall.allowedTCPPorts = [ 9000 ];

    services.caddy.virtualHosts."${cfg.url}" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:9001
      '';
    };
  };
}
