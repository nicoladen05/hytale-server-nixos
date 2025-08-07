{ ... }:

{
  imports = [
    ./caddy.nix

    ./homeassistant
    ./tailscale
    ./minecraft
    ./windows
  ];
}
