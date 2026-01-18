{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.homelab.services.pyrodactyl;
in
{
  options.homelab.services.pyrodactyl = {
    enable = lib.mkEnableOption "Pyrodactyl service";
    path = lib.mkOption {
      type = lib.types.path;
      default = "${config.homelab.configDir}/pyrodactyl";
    };
    httpPort = lib.mkOption {
      type = lib.types.int;
      default = 8080;
    };
    httpsPort = lib.mkOption {
      type = lib.types.int;
      default = 8443;
    };
    url = lib.mkOption {
      type = lib.types.str;
      default = "panel.${config.homelab.baseDomain}";
    };
  };

  config =
    let
      dbName = "panel";
      dbUser = "pyrodactyl";
    in
    lib.mkIf cfg.enable {
      systemd.tmpfiles.rules = [
        "d ${cfg.path} 0775 pyrodactyl users -"
        "d ${cfg.path}/database 0775 pyrodactyl users -"
        "d ${cfg.path}/var 0775 pyrodactyl users -"
        "d ${cfg.path}/nginx 0775 pyrodactyl users -"
        "d ${cfg.path}/certs 0775 pyrodactyl users -"
        "d ${cfg.path}/logs 0775 pyrodactyl users -"
      ];

      users.users.pyrodactyl = {
        isSystemUser = true;
        name = "pyrodactyl";
        group = "users";
      };

      virtualisation.containers.enable = true;
      virtualisation.oci-containers.backend = "podman";
      virtualisation = {
        podman = {
          enable = true;
          dockerCompat = true;
          defaultNetwork.settings.dns_enabled = false;
        };
      };

      # Database
      services.mysql = {
        enable = true;
        package = pkgs.mariadb;
        ensureDatabases = [ dbName ];
        ensureUsers = [
          {
            name = dbUser;
            ensurePermissions = {
              "${dbName}.*" = "ALL PRIVILEGES";
            };
          }
        ];
        user = "pyrodactyl";
      };

      # Redis
      services.redis.servers.pyrodactyl = {
        enable = true;
        port = 6380;
        bind = "0.0.0.0";
      };

      # Panel
      virtualisation.oci-containers.containers."pyrodactyl-panel" = {
        image = "ghcr.io/pyrohost/pyrodactyl:latest";
        autoStart = true;
        pull = "newer";
        ports = [
          "${builtins.toString cfg.httpPort}:80"
          "${builtins.toString cfg.httpsPort}:443"
        ];
        environment = {
          APP_URL = "https://${cfg.url}";
          APP_SERVICE_AUTHOR = "noreply@${cfg.url}";
          APP_ENV = "production";
          APP_KEY = "base64:g617PTArwVQJ4T5NBA3GrI8xb65kUcb1I0AbHagYP0k=";
          APP_ENVIRONMENT_ONLY = "false";
          CACHE_DRIVER = "redis";
          SESSION_DRIVER = "redis";
          QUEUE_DRIVER = "redis";
          REDIS_HOST = "host.docker.internal";
          REDIS_PORT = "6380";
          DB_CONNECTION = "mysql";
          DB_HOST = "host.docker.internal";
          DB_PORT = "3306";
          DB_DATABASE = "panel";
          DB_USERNAME = "pyrodactyl";
          DB_PASSWORD = "changeme";
          HASHIDS_LENGTH = "8";
        };
        volumes = [
          "${cfg.path}/var:/app/var/"
          "${cfg.path}/nginx:/etc/nginx/http.d/"
          "${cfg.path}/certs:/etc/letsencrypt/"
          "${cfg.path}/logs:/app/storage/logs/"
        ];
        extraOptions = [
          "--add-host=host.docker.internal:host-gateway"
        ];
      };

      networking.firewall.allowedTCPPorts = [
        8443
        3306
        6380
      ];

      services.caddy.virtualHosts = {
        "${cfg.url}" = {
          extraConfig = ''
            
                        
                                    reverse_proxy 127.0.0.1:${builtins.toString cfg.httpPort}
          '';
        };
      };
    };
}
