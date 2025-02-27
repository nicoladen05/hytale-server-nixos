{ lib, pkgs, config, ... }:

{
  options = {
    virtualization.docker.enable = lib.mkEnableOption "enable docker";
  };

  config = lib.mkIf {
    virtualisation.docker.enable = true;
    hardware.nvidia-container-toolkit.enable = lib.optional config.system.nvidia.enable true;
    users.users."${config.system.userName}".extraGroups = [ "docker" ];
  };
}
