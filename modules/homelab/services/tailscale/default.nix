{ pkgs, lib, config, ... }:

{
  options = {
    tailscale.enable = lib.mkEnableOption "enable tailscale";
  };

  config = {
    services.tailscale.enable = true;
    services.tailscale.useRoutingFeatures = "server";
  };
}
