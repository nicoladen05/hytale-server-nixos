{ ... }:

{
  imports = [
    ./caddy.nix
    ./ddns.nix

    ./backup
    ./blocky
    ./botify
    ./code-server
    ./glance
    ./homeassistant
    ./immich
    ./media
    ./minecraft
    ./n8n
    ./ocis
    ./paperless
    ./pihole
    ./pyrodactyl
    ./spoolman
    ./vaultwarden
    ./windows
    ./wireguard
  ];
}
