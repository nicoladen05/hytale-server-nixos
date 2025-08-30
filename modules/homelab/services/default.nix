{ ... }:

{
  imports = [
    ./caddy.nix
    ./wireguard.nix

    ./homeassistant
    ./tailscale
    ./minecraft
    ./windows
  ];
}
