{ lib, config, pkgs, inputs, ... }:

{
  options = {
    packages.enable = lib.mkEnableOption "enable basic packages";

    packages.terminal.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };

    packages.coding.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };

    packages.desktop.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };

    packages.gaming.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };

    packages.productivity.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.packages.enable {
    # Essentials
    environment.systemPackages = with pkgs; [
      git
      killall
      wget
      gcc
      htop
      deploy-rs
    ]
    ++ lib.optionals config.packages.terminal.enable [
      lazygit
      eza
      neovim
    ]
    ++ lib.optionals config.packages.gaming.enable [
        mangohud

        (prismlauncher.override {
          jdks = [
            zulu
          ];
        })
    ];

    users.users."${config.system.userName}" = {
      packages = with pkgs; [
          git-crypt
          fontconfig
      ]
      ++ lib.optionals config.packages.desktop.enable [
          pcmanfm
          discord
          spotify
          spotify-player

          poppler
          ueberzugpp

          pavucontrol
          pamixer

          bottles

          inputs.zen-browser.packages."${system}".default
      ]
      ++ lib.optionals config.packages.coding.enable [
          python3
          nodejs_22 pnpm
          cargo
          runc
      ]
      ++ lib.optionals config.packages.productivity.enable [
        (obsidian.override {
          electron = electron_32.overrideAttrs (_: {
            preFixup = "patchelf --add-needed ${libglvnd}/lib/libEGL.so.1 $out/bin/electron";
            meta.knownVulnerabilities = [ ];
          });
        })
        nextcloud-client
        anki
      ];
    };

    nixpkgs.config.permittedInsecurePackages = lib.optionals config.packages.productivity.enable [
      "electron-25.9.0"
    ];

    programs.zsh.enable = lib.mkIf config.packages.terminal.enable true;
  };
}
