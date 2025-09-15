{ ... }:

{
  imports = [
    ./caddy.nix
    ./wireguard.nix

    ./homeassistant
    ./windows
    ./immich
  ];
}
