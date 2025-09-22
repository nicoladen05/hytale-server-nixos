{
  lib,
  pkgs,
  config,
  ...
}:
{
  options = {
    desktop.hyprland.enable = lib.mkEnableOption "enable hyprland";
  };

  config = lib.mkIf config.desktop.hyprland.enable {
    environment.systemPackages = [
      pkgs.libnotify

      pkgs.wl-clipboard

      pkgs.hyprshot
      pkgs.grim

      pkgs.slurp

      (pkgs.writeScriptBin "rofi-power-menu" ''
        options="󰌾 Lock\n󰤄 Sleep\n󰜉 Reboot\n󰐥 Shutdown"

        selected=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu")

        case "''${selected}" in
           "󰐥 Shutdown")
              systemctl poweroff
              ;;
           "󰜉 Reboot")
              systemctl reboot
              ;;
           "󰤄 Sleep")
              hyprshot -m output -m DP-6 -o /tmp -f screenshot.png -s ; hyprlock & systemctl suspend
              ;;
           "󰌾 Lock")
              hyprshot -m output -m DP-6 -o /tmp -f screenshot.png -s ; hyprlock
              ;;
        esac
      '')
    ];

    programs.uwsm.enable = true;

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };

    environment.sessionVariables = lib.mkIf config.system.nvidia.enable {
      # WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";

      __GL_GSYNC_ALLOWED = "1";
      LIBVA_DRIVER_NAME = "nvidia";
    };

    xdg.portal.enable = true;
    # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

    #   services.greetd = {
    #     enable = true;
    #     settings = {
    #       default_session = {
    #         command = "Hyprland";
    #         user = config.system.userName;
    #       };
    #     };
    #   };
  };
}
