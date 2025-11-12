{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.homelab.services.glance.agent;
in
{
  options.homelab.services.glance.agent = {
    enable = lib.mkEnableOption "Enable the Glance Agent";

    package = lib.mkPackageOption pkgs "glance-agent" {
      default = (pkgs.callPackage ../../../../packages/glance-agent.nix { });
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "glance-agent";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "glance-agent"
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      inherit (cfg) group;
      description = "Glance Agent service user";
    };
    users.groups.${cfg.group} = { };

    systemd.services.glance-agent = {
      description = "Glance Agent Service";
      
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      startLimitIntervalSec = 300;
      startLimitBurst = 3;

      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStart = "${cfg.package}/bin/agent";

        User = cfg.user;
        Group = cfg.group;
      };
    };
  };
}
