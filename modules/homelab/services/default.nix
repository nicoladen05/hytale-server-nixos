{ ... }:

{
  imports = [
    ./caddy.nix
    ./wireguard.nix

    ./botify
    ./homeassistant
    ./windows
    ./immich
  ];
}
