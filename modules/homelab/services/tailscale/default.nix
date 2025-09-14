{ pkgs, lib, config, ... }:

{
  options = {
    tailscale.enable = lib.mkEnableOption "enable tailscale";
  };

  config = lib.mkIf config.tailscale.enable {
    services.tailscale.enable = true;
    services.tailscale.useRoutingFeatures = "server";
  };
}
