{ ... }:

{
  imports = [
    ./caddy.nix
    ./wireguard.nix

    ./blocky
    ./botify
    ./homeassistant
    ./immich
    ./ocis
    ./pihole
    ./vaultwarden
    ./windows
  ];
}
