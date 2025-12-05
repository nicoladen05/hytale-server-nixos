{
  lib,
  config,
  ...
}:
{
  options = {
    desktop.kde.enable = lib.mkEnableOption "KDE Plasma desktop environment";
  };

  config = lib.mkIf config.desktop.kde.enable {
    services = {
      desktopManager.plasma6.enable = true;
      displayManager.sddm.enable = true;
      displayManager.sddm.wayland.enable = true;
      displayManager.sddm.settings.General.DisplayServer = "wayland";
    };
  };
}
