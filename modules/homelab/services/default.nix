{ ... }:

{
  imports = [
    ./caddy.nix
    ./wireguard.nix

    ./homeassistant
    ./tailscale
    ./windows
  ];
}
