{
  config,
  lib,
  ...
}: {
  options = {
    desktop.gnome.enable = lib.mkEnableOption "enable gnome";
  };

  config = lib.mkIf config.desktop.gnome.enable {
    services.xserver = {
      enable = true;

      displayManager.gdm = {
        enable = true;
      };

      desktopManager.gnome.enable = true;
    };
  };
}
