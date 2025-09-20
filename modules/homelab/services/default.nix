{ ... }:

{
  imports = [
    ./caddy.nix
    ./ddns.nix

    ./blocky
    ./botify
    ./homeassistant
    ./immich
    ./ocis
    ./pihole
    ./vaultwarden
    ./windows
    ./wireguard
  ];
}
