{ lib, config, ... }:

{
  options = {
    system.sops = {
      enable = lib.mkEnableOption "enable sops";

      secretsFile = lib.mkOption {
        type = lib.types.path;
        default = ../../../secrets/secrets.yaml;
      };

      ageKeyFile = lib.mkOption {
        type = lib.types.path;
        default = builtins.toPath "/home/${config.system.userName}/.config/sops/age/keys.txt";
      };
    };
  };

  config = lib.mkIf config.system.sops.enable {
    sops.defaultSopsFile = config.system.sops.secretsFile;
    sops.defaultSopsFormat = "yaml";

    sops.age.keyFile = config.system.sops.ageKeyFile;

    sops.secrets."user/nico/password" = { };
    sops.secrets."user/nico/password_long" = { };
    sops.secrets."user/nico/password_hash" = {
      neededForUsers = true;
    };

    sops.secrets."services/botify/token" = { };
    sops.secrets."wireguard/privkey" = {
      mode = "0640";
      owner = "systemd-network";
    };

    sops.secrets."cloudflare/api_token" = { };

    sops.secrets."restic/password" = { };
    sops.secrets."restic/repository" = { };

    sops.secrets."glance_restic/password" = { };
    sops.secrets."glance_restic/url" = { };
  };
}
