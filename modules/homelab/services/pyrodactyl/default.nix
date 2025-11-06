{ lib, config, ... }:

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

  config = lib.mkIf cfg.enable {
    users.users.pyrodactyl = {
      name = "pyrodactyl";
      uid = 2001;
      group = "users";
      isSystemUser = true;
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.path} 0775 pyrodactyl users -"
      "d ${cfg.path}/database 0775 pyrodactyl users -"
      "d ${cfg.path}/var 0775 pyrodactyl users -"
      "d ${cfg.path}/nginx 0775 pyrodactyl users -"
      "d ${cfg.path}/certs 0775 pyrodactyl users -"
      "d ${cfg.path}/logs 0775 pyrodactyl users -"
    ];

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
    virtualisation.oci-containers.containers."pyrodactyl-db" = {
      image = "docker.io/library/mariadb:latest";
      autoStart = true;
      volumes = [
        "${cfg.path}/database:/var/lib/mysql"
      ];
      environment = {
        MYSQL_PASSWORD = "changeme";
        MYSQL_ROOT_PASSWORD = "changeme";
        MYSQL_DATABASE = "panel";
        MYSQL_USER = "pterodactyl";
      };
      user = "2001:100";
    };

    # Cache
    virtualisation.oci-containers.containers."pyrodactyl-redis" = {
      image = "docker.io/library/redis:latest";
      autoStart = true;
      user = "2001:100";
    };

    # Panel
    virtualisation.oci-containers.containers."pyrodactyl-panel" = {
      image = "ghcr.io/pyrohost/pyrodactyl:latest";
      autoStart = true;
      ports = [ "${builtins.toString cfg.httpPort}:80" "${builtins.toString cfg.httpsPort}:443" ];
      environment = {
        APP_URL = "https://${cfg.url}";
        APP_TIMEZONE = config.system.timeZone;
        APP_SERVICE_AUTHOR = "noreply@${cfg.url}"; 
        APP_ENV = "production";
        APP_ENVIRONMENT_ONLY = "false";
        CACHE_DRIVER = "redis";
        SESSION_DRIVER = "redis";
        QUEUE_DRIVER = "redis";
        REDIS_HOST = "10.0.0.68";
        DB_CONNECTION = "mysql";
        DB_HOST = "10.0.0.68";
        DB_PORT = "3306";
        DB_DATABASE = "panel";
        DB_USERNAME = "pterodactyl";
        DB_PASSWORD = "changeme";
        HASHIDS_LENGTH = "8";
      };
      volumes = [
        "${cfg.path}/var:/app/var/"
        "${cfg.path}/nginx:/etc/nginx/http.d/"
        "${cfg.path}/certs:/etc/letsencrypt/"
        "${cfg.path}/logs:/app/storage/logs/"
      ];
      dependsOn = [
        "pyrodactyl-db"
        "pyrodactyl-redis"
      ];
      user = "2001:100";
    };

    services.caddy.virtualHosts."${cfg.url}" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:${builtins.toString cfg.httpPort}
      '';
    };
  };
}
