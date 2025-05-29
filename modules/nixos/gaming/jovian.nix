{
  lib,
  config,
  ...
}: {
  options = {
    gaming.jovian.enable = lib.mkEnableOption "Enable Jovian";
  };

  config = lib.mkIf config.gaming.jovian.enable {
    jovian = {
      decky-loader = {
        enable = true;
      };
      steam = {
        enable = true;
        user = config.system.userName;
        autoStart = true;
        desktopSession = "hyprland-uwsm";
      };
      steamos.useSteamOSConfig = true;
    };
  };
}
