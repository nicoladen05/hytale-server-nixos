{ lib, pkgs, config, inputs, ... }:

let
  cfg = config.programs.winboat;
in
{
  options.programs.winboat = {
    enable = lib.mkEnableOption "Enable winboat";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      inputs.winboat.packages.x86_64-linux.winboat
      pkgs.freerdp
    ];

    virtualisation.docker.enable = true;
    users.users."${config.system.userName}".extraGroups = [ "docker" ];
  };
}
