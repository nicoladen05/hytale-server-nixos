{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.services.hytale-server;

  # Build command line flags from options
  serverFlags = lib.concatStringsSep " " (
    lib.filter (x: x != "") [
      "--auth-mode ${cfg.authMode}"
      "--universe ${cfg.universe}"
      "--assets ${cfg.assets}"
      "--bind 0.0.0.0:${toString cfg.serverPort}"
      (lib.optionalString cfg.acceptEarlyPlugins "--accept-early-plugins")
      (lib.optionalString cfg.backup.enable "--backup-path ${cfg.backup.path}")
      (lib.optionalString cfg.backup.enable "--backup-frequency ${toString cfg.backup.frequency}")
      (lib.optionalString cfg.backup.enable "--backup-max-count ${toString cfg.backup.maxCount}")
    ]
  );

  jvmFlags = lib.concatStringsSep " " cfg.jvmOptions;
in
{
  options.services.hytale-server = {
    enable = lib.mkEnableOption "Enable the Hytale server";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ../../pkgs/hytale-server { };
      defaultText = lib.literalExpression "pkgs.hytale-server";
      description = "The Hytale server package to use";
    };
    #
    javaPackage = lib.mkOption {
      type = lib.types.package;
      default = pkgs.jdk25;
      defaultText = lib.literalExpression "pkgs.jdk25";
      description = "The Java package to use for running the server";
    };

    jvmOptions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Extra JVM options to pass to the Hytale server";
    };

    acceptEarlyPlugins = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "You acknowledge that loading early plugins is unsupported and may cause stability issues.";
    };

    authMode = lib.mkOption {
      type = lib.types.enum [
        "authenticated"
        "offline"
        "insecure"
      ];
      default = "authenticated";
      description = "Authentication mode for the Hytale server. One of the following: authenticated, offline, insecure";
    };

    serverPort = lib.mkOption {
      type = lib.types.port;
      default = 5520;
      description = "The UDP port for the Hytale server to listen on.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the server port in the firewall.";
    };

    backup = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "Enable backup";
          path = lib.mkOption {
            type = lib.types.path;
            default = "/var/lib/hytale-server/backup";
            description = "Path to the backup directory";
          };
          frequency = lib.mkOption {
            type = lib.types.int;
            default = 30;
            description = "Frequency of backups in minutes";
          };
          maxCount = lib.mkOption {
            type = lib.types.int;
            default = 5;
            description = "Maximum number of backups to keep";
          };
        };
      };
      default = { };
    };

    universe = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/hytale-server/universe/worlds/default";
      description = "Path to the universe directory";
    };

    assets = lib.mkOption {
      type = lib.types.path;
      description = "Path to the assets directory. This is required to run the server.";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/hytale-server";
      description = "Directory to store Hytale server data";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "hytale-server";
      description = "User account under which the server runs";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "hytale-server";
      description = "Group under which the server runs";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedUDPPorts = lib.mkIf cfg.openFirewall [ cfg.serverPort ];

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      description = "Hytale server user";
    };

    users.groups.${cfg.group} = { };

    systemd.services.hytale-server = {
      description = "Hytale Game Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.dataDir;
        StateDirectory = "hytale-server";
        ExecStart = "${cfg.javaPackage}/bin/java ${jvmFlags} -jar ${cfg.package}/share/java/hytale-server/hytale-server.jar ${serverFlags}";
        Restart = "on-failure";
        RestartSec = "10s";
        StandardInput = "socket";
        StandardOutput = "journal";
        StandardError = "journal";
      };

      preStart = ''
        mkdir -p ${cfg.dataDir}
        ${lib.optionalString cfg.backup.enable "mkdir -p ${cfg.backup.path}"}

        # Ensure proper permissions on data directory
        chown ${cfg.user}:${cfg.group} ${cfg.dataDir}
        chmod 750 ${cfg.dataDir}
      '';
    };

    systemd.sockets.hytale-server = {
      requires = [ "hytale-server.service" ];
      partOf = [ "hytale-server.service" ];
      socketConfig = {
        ListenFIFO = "/run/hytale-server.stdin";
        SocketMode = "0660";
        SocketUser = cfg.user;
        SocketGroup = cfg.group;
        RemoveOnStop = true;
        FlushPending = true;
      };
    };

    environment.systemPackages = [
      (pkgs.writeShellScriptBin "hytale-console" ''
        exec ${pkgs.tmux}/bin/tmux -S ${cfg.dataDir}/hytale.sock attach-session -t hytale
      '')
    ];
  };
}
