{ lib, config, pkgs, ... }:

let
  cfg = config.homelab.services.botify;

  environment = pkgs.python312.withPackages(p: with p; [
  ])
in
{
  options.homelab.services.botify = {
    enable = lib.mkEnableOption "Enable Botify Bot";
  };

  config = lib.mkIf cfg.enable {
  };
}
