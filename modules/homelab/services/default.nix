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
    ./minecraft
    ./n8n
    ./ocis
    ./pihole
    ./pyrodactyl
    ./vaultwarden
    ./windows
    ./wireguard
  ];
}
