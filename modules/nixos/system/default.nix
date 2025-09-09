{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./nh.nix
    ./nvidia.nix
    ./sops.nix
  ];

  options = {
    system = {
      enable = lib.mkEnableOption "enable the basic system configuration";

      userName = lib.mkOption {
        type = lib.types.str;
        default = "nico";
      };

      passwordFile = lib.mkOption {
        type = lib.types.path;
      };

      hostName = lib.mkOption {
        type = lib.types.str;
      };

      timeZone = lib.mkOption {
        type = lib.types.str;
        default = "Europe/Berlin";
        example = "Europe/Berlin";
      };

      locale.language = lib.mkOption {
        type = lib.types.str;
        default = "en_US.UTF-8";
        example = "en_US.UTF-8";
      };

      locale.unitFormat = lib.mkOption {
        type = lib.types.str;
        default = "de_DE.UTF-8";
        example = "de_DE.UTF-8";
      };

      shell = lib.mkOption {
        type = lib.types.package;
        default = pkgs.bash;
        example = pkgs.zsh;
      };

      boot.systemdBoot = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
      };

      bluetooth.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
      };

      tcpPorts = lib.mkOption {
        type = lib.types.listOf lib.types.int;
        default = [ ];
        example = [ 22 ];
      };

      udpPorts = lib.mkOption {
        type = lib.types.listOf lib.types.int;
        default = [ ];
        example = [ 22 ];
      };

      ssh = {
        enable = lib.mkOption { type = lib.types.bool; default = false; };
        allowEmptyPasswords = lib.mkOption { type = lib.types.bool; default = false; };
      };
    };
  };

  config = lib.mkIf config.system.enable {
    nh.enable = true;

    # Bootloader.
    boot.loader.systemd-boot.enable = lib.mkIf config.system.boot.systemdBoot true;
    boot.loader.efi.canTouchEfiVariables = lib.mkIf config.system.boot.systemdBoot true;

    # Networking
    networking.hostName = "${config.system.hostName}";
    networking.networkmanager.enable = true;

    # Timezone
    time.timeZone = "${config.system.timeZone}";

    # Locale
    i18n.defaultLocale = "${config.system.locale.language}";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "${config.system.locale.unitFormat}";
      LC_IDENTIFICATION = "${config.system.locale.unitFormat}";
      LC_MEASUREMENT = "${config.system.locale.unitFormat}";
      LC_MONETARY = "${config.system.locale.unitFormat}";
      LC_NAME = "${config.system.locale.unitFormat}";
      LC_NUMERIC = "${config.system.locale.unitFormat}";
      LC_PAPER = "${config.system.locale.unitFormat}";
      LC_TELEPHONE = "${config.system.locale.unitFormat}";
      LC_TIME = "${config.system.locale.unitFormat}";
    };

    # Users
    users.users."${config.system.userName}" = {
      isNormalUser = true;
      description = "${config.system.userName}";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      shell = config.system.shell;
      hashedPassword = "$6$FdDJt3LLc3Iu0r14$DKRv42b0IsqkW6OFkWr0WnUoxMPPaFUnSZgBFJKfR4elFeGRU3NfhP1rXbWd.b9073ZucRQrFto130F3eBVjj0";
      # hashedPasswordFile = "${config.system.passwordFile}";
    };

    users.users.root = {
      hashedPassword = "$6$FdDJt3LLc3Iu0r14$DKRv42b0IsqkW6OFkWr0WnUoxMPPaFUnSZgBFJKfR4elFeGRU3NfhP1rXbWd.b9073ZucRQrFto130F3eBVjj0";
    };

    # Bluetooth
    hardware.bluetooth = lib.mkIf config.system.bluetooth.enable {
      enable = true;
      powerOnBoot = true;
      settings.General = {
        experimental = true;
        Privacy = "device";
        JustWorksRepairing = "always";
        Class = "0x000100";
        FastConnectable = true;
      };
    };
    services.blueman.enable = lib.mkIf config.system.bluetooth.enable true;

    networking.firewall.allowedTCPPorts = config.system.tcpPorts;
    networking.firewall.allowedUDPPorts = config.system.udpPorts;

    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
