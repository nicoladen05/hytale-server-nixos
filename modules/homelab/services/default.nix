{ ... }:

{
  imports = [
    ./caddy.nix

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
