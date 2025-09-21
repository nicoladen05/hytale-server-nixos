{ ... }:

{
  imports = [
    ./caddy.nix
    ./ddns.nix

    ./blocky
    ./botify
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
