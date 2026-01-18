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
          url = "https://github.com/nitrado/hytale-plugin-webserver/releases/download/v1.0.0/nitrado-webserver-1.0.0.jar";
          hash = "sha256-nO/oCsE5c22SBzPZO90kydR1VCvCioK4+QG9BCsE1eM=";
        })

        (pkgs.fetchurl {
          url = "https://github.com/nitrado/hytale-plugin-query/releases/download/v1.0.1/nitrado-query-1.0.1.jar";
          hash = "sha256-hDt8wDLNnupA8i3e7VoQFsnkH7cgmkvbOyL+x0uLxCQ=";
        })
      ];
    };

    # This is the port used by the nitrado query plugin
    networking.firewall.allowedTCPPorts = [ 5523 ];
  };
}
