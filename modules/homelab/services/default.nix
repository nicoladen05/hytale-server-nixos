{ ... }:

{
  imports = [
    ./caddy.nix
    ./ddns.nix

    ./backup
    ./blocky
    ./botify
    ./code-server
    ./homeassistant
    ./immich
    ./media
    ./n8n
    ./ocis
    ./pihole
    ./vaultwarden
    ./windows
    ./wireguard
  ];
}
