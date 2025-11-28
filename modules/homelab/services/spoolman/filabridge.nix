{ lib, config, pkgs, ... }:

let
  cfg = config.homelab.services.spoolman.filabridge;
  filabridgePkg = pkgs.callPackage ../../../../packages/filabridge.nix {};
in
{
  options.homelab.services.spoolman.filabridge = {
    enable = lib.mkEnableOption "filabridge";
    port = lib.mkOption {
      type = lib.types.int;
      default = 7913;
      description = "The port to listen on";
    };
    host = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "The host to listen on";
    };
    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/filabridge";
      description = "The directory where filabridge stores its data";
    };
    user = lib.mkOption {
      type = lib.types.str;
      default = "filabridge";
      description = "The user to run filabridge as";
    };
    group = lib.mkOption {
      type = lib.types.str;
      default = "filabridge";
      description = "The group to run filabridge as";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      inherit (cfg) group;
      description = "User for filabridge";
    };
    users.groups.${cfg.group} = {};

    systemd.services.filabridge = {
      description = "Filabridge";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStart = "${filabridgePkg}/bin/filabridge --port ${builtins.toString cfg.port} --host ${cfg.host}";
        WorkingDirectory = cfg.dataDir;

        User = cfg.user;
        Group = cfg.group;
      };
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
