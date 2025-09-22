{ ... }:

{
  imports = [
    ./caddy.nix
    ./ddns.nix

    ./blocky
    ./botify
    ./backup
    ./homeassistant
    ./immich
    ./media
    ./ocis
    ./pihole
    ./vaultwarden
    ./windows
    ./wireguard
  ];
}
