{ lib, config, inputs, pkgs, ... }:

let
  cfg = config.homelab.services.assetto-corsa-server;
in
{
  imports = [ inputs.flux.nixosModules.default ];

  options.homelab.services.assetto-corsa-server = {
    enable = lib.mkEnableOption "Enable assetto-corsa-server";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.flux.overlays.default ];

    flux = {
      enable = true;
      servers = {
        assetto-corsa =
        let
          serverPackage = pkgs.fetchSteam {
            name = "assetto-corsa-server";
            appId = "302550";
            hash = "sha256-dYctaT5X3z2p0jbPdqvUigmcPcKGS5nFizYoqyY+OhQ=";
          };
        in
        {
          package = serverPackage.overrideAttrs {
            builder = ./build.sh;
          };
        };
      };
    };
  };
}
