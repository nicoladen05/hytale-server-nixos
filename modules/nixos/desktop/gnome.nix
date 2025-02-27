{ config, lib, ...}:

{
  options = {
    desktop.gnome.enable = lib.mkEnableOption "enable gnome";
  };

  config = lib.mkIf config.desktop.gnome.enable {
    services.xserver = {
      enable = true;

      displayManager.gdm = {
        enable = true;
        wayland = true;
      };

      desktopManager.gnome.enable = true;

      xkb = {
        layout = "us";
        variant = "colemak";
        options = "caps:swapescape";
      };
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    programs.xwayland.enable = true;
  };

}
