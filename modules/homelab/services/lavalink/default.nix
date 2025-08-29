{ lib, config, ... }:

# not finished

let
    cfg = homelab.services.lavalink;
in
{
    options = {
        cfg.enable = lib.mkEnableOption "enable lavalink";
    };

    config = lib.mkIf cfg.enable {
        virtualisation.oci-containers.containers."lavalink" = {
            image = "ghcr.io/lavalink-devs/lavalink:4-alpine";
            autoStart = true;
            environment = {
                _JAVA_OPTIONS= "-Xmx4G";
                LAVALINK_SERVER_PASSWORD = "pass"; # TODO: Change
            };
            volumes = {

            };
        };
    };
}