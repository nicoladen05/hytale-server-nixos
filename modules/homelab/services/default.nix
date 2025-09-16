{ ... }:

{
  imports = [
    ./caddy.nix
    ./wireguard.nix

    ./botify
    ./pihole
    ./homeassistant
    ./windows
    ./immich
  ];
}
