{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.programs.winboat;
in
{
  options.programs.winboat = {
    enable = lib.mkEnableOption "Enable winboat";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.freerdp
      pkgs.winboat
    ];

    virtualisation.docker.enable = true;
    users.users."${config.system.userName}".extraGroups = [ "docker" ];
  };
}
