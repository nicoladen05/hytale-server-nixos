{ ... }:

{
  imports = [
    ./caddy.nix
    ./wireguard.nix

    ./botify
    ./blocky
    ./pihole
    ./homeassistant
    ./windows
    ./immich
  ];
}
