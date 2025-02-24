{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  options = {
    desktop.enable = lib.mkEnableOption "enable the basic desktop";

    desktop.userName = lib.mkOption {
      type = lib.types.str;
    };

    desktop.hostName = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.desktop.enable {
    nh.enable = true;

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "${config.desktop.hostName}";

    # Enable networking
    networking.networkmanager.enable = true;

    # Set your time zone.
    time.timeZone = "Europe/Berlin";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };

    # Nvidia
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    hardware.graphics.enable = true;
    services.xserver.videoDrivers = ["nvidia"];

    # Enable CUPS to print documents.
    services.printing.enable = false;

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    nixpkgs.config.permittedInsecurePackages = [
      "electron-25.9.0"
    ];

    users.users."${config.desktop.userName}" = {
      isNormalUser = true;
      description = "${config.desktop.userName}";
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.zsh;
      packages = with pkgs; [
        # Essentials
        pcmanfm
        discord
        spotify
        spotify-player

        # Schule
        (obsidian.override {
          electron = electron_32.overrideAttrs (_: {
            preFixup = "patchelf --add-needed ${libglvnd}/lib/libEGL.so.1 $out/bin/electron";
            meta.knownVulnerabilities = [ ];
          });
        })
        nextcloud-client
        anki

        inputs.zen-browser.packages."${system}".default

        poppler
        ueberzugpp

        # Dev Tools
        python3
        nodejs_22
        cargo

        pavucontrol
        pamixer

        lazygit

        rxvt-unicode
        xterm
        fontconfig

        git-crypt

        bottles

        tomato-c
      ];
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      git
      killall
      lazygit
      wget
      stow
      gcc
      playerctl
      mangohud
      eza
      htop
      neovim
      codeium

      # Coding
      pnpm

      runc

      (prismlauncher.override {
        jdks = [
          zulu
        ];
      })
    ];

    programs.zsh.enable = true;

    services.gvfs.enable = true;

    services.gnome.gnome-keyring.enable = true;

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # services.pcscd.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    #   pinentryPackage = pkgs.pinentry-rofi;
    # };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    # Open ports in the firewall.
    networking.firewall.allowedTCPPorts = [ 22 25565 11434 ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.05"; # Did you read the comment?
  };
}
