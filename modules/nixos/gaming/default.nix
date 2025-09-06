{
  config,
  lib,
  ...
}:
{
  imports = [
    ./steam.nix
    ./controller.nix
  ];

  options = {
    gaming.enable = lib.mkEnableOption "Enable a gaming environment";
  };

  config = lib.mkIf config.gaming.enable {
    gaming.steam.enable = true;
  };
}
