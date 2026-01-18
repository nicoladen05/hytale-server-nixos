{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:

let
  cfg = config.homelab.services.hytale-server;
in
{
  imports = [ inputs.hytale-server-nix.nixosModules.default ];

  options.homelab.services.hytale-server = {
    enable = lib.mkEnableOption "Hytale Server";
  };

  config = lib.mkIf cfg.enable {
    services.hytale-server = {
      enable = true;
      assets = "/var/lib/hytale-server/assets.zip";
      openFirewall = true;
      jvmOptions = [
        "-Xmx4G"
        "-Xms4G"
      ];
    };
  };
}
