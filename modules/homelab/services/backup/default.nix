{ lib, config, ... }:

let
  cfg = config.homelab.services.backup;
  services = config.homelab.services;
in
{
  options.homelab.services.backup = {
    enable = lib.mkEnableOption "Enable Backups through restic";

    repositoryFile = lib.mkOption {
      type = lib.types.str;
      example = "sftp:backup@192.168.1.100:/backups";
    };

    passwordFile = lib.mkOption {
      type = lib.types.path;
    };

    environmentFile = lib.mkOption {
      type = lib.types.path;
    };
  };

  config = lib.mkIf cfg.enable {
    # OCIS
    services.restic.backups."ocis" = lib.mkIf services.ocis.enable {
      inherit (cfg) repositoryFile passwordFile environmentFile;
      timerConfig = {
        OnCalendar = "03:00";
      };
      paths = [ "/data/ocis" ];
      pruneOpts = [ "--keep-daily 2" ];
    };

    # Vaultwarden
    services.restic.backups."vaultwarden" = lib.mkIf services.vaultwarden.enable {
      inherit (cfg) repositoryFile passwordFile environmentFile;
      timerConfig = {
        OnCalendar = "03:05";
      };
      paths = [ services.vaultwarden.backupDir ];
      pruneOpts = [ "--keep-daily 3" "--keep-weekly 1" ];
    };

    # Immich
    services.restic.backups."immich" = lib.mkIf services.immich.enable {
      inherit (cfg) repositoryFile passwordFile environmentFile;
      timerConfig = {
        OnCalendar = "03:10";
      };
      paths = [ services.immich.mediaLocation ];
      pruneOpts = [ "--keep-daily 1" "--keep-weekly 1" ];
    };
  };
}
