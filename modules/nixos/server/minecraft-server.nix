{ lib, pkgs, config, inputs, ... }:

{
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  options = {
    minecraft-server.enable = lib.mkEnableOption "enable the minecraft server";
  };

  config = lib.mkIf config.minecraft-server.enable {
    nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

    services.minecraft-servers = {
      enable = true;
      eula = true;

      servers = {
        minecraft-winter = {
          enable = true;
          package = pkgs.fabricServers.fabric-1_21_1;
        };
      };
    };
  };
}
