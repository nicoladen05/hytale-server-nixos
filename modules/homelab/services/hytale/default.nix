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

      plugins = [
        (pkgs.fetchurl {
          url = "https://github.com/G-PORTAL/hytale-plugin-query/releases/download/1.1.1/gportal-query-1.1.1.jar";
          hash = "sha256-U2rfAWB5x0Oatus+X8Epa4AkUrYts2v2lUm/lufUJIs=";
        })
      ];
    };

    # This is the port used by the query plugin
    networking.firewall.allowedUDPPorts = [ 5521 ];
  };
}
