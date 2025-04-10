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
      steam = {
        enable = true;
        user = config.system.userName;
      };
      steamos.useSteamOSConfig = true;
    };
  };
}
