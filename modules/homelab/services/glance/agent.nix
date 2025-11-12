{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.homelab.services.glance.agent;
  glanceAgent = builtins.fetchTarball {
    url = "https://github.com/glanceapp/agent/releases/download/v0.1.0/agent-linux-arm64.tar.gz";
    sha256 = "0rzv3xl8d2668rnyklznnfmmrn4jjbahfs5vimmv4k3av6r7npa1";
  };
in
{
  options.homelab.services.glance.agent = {
    enable = lib.mkEnableOption "Enable the Glance Agent";

    user = lib.mkOption {
      type = lib.types.str;
      default = "glance-agent";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "glance-agent";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        options = {
          tokenFile = lib.mkOption {
            type = lib.types.str;
            description = "Path to a file containing the authentication token for the Glance Agent.";
          };
          logLevel = lib.mkOption {
            type = lib.types.enum [
              "debug"
              "info"
              "warn"
              "error"
            ];
            default = "info";
            description = "Logging level for the Glance Agent.";
          };
          port = lib.mkOption {
            type = lib.types.int;
            default = 27973;
            description = "Port on which the Glance Agent will listen.";
          };
        };
      };
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      inherit (cfg) group;
      description = "Glance Agent service user";
    };
    users.groups.${cfg.group} = { };

    networking.firewall.allowedTCPPorts = [ cfg.settings.port ];

    systemd.services.glance-agent = {
      description = "Glance Agent Service";

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      startLimitIntervalSec = 300;
      startLimitBurst = 3;

      environment = {
        LOG_LEVEL = cfg.settings.logLevel;
        PORT = toString cfg.settings.port;
      };

      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStart = "${glanceAgent}/agent";

        EnvironmentFile = cfg.settings.tokenFile;

        User = cfg.user;
        Group = cfg.group;
      };
    };
  };
}
