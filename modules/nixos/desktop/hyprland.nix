{ lib, pkgs, config, ... }:

{
  options = {
    desktop.hyprland.enable = lib.mkEnableOption "enable hyprland";
  };

  config = lib.mkIf {
    environment.systemPackages = [
      pkgs.libnotify

      pkgs.wl-clipboard

      pkgs.hyprshot
      pkgs.grim

      pkgs.slurp
      pkgs.hyprsunset
      
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
            hyprshot -m output -m DP-6 -o /tmp -f screenshot.png -s ; hyprlock ; systemctl suspend
            ;;
         "󰌾 Lock")
            hyprshot -m output -m DP-6 -o /tmp -f screenshot.png -s ; hyprlock
            ;;
      esac
      '')
    ];


    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    environment.sessionVariables = lib.optional config.system.nvidia.enable {
      # WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";

      __GL_GSYNC_ALLOWED = "1";
      LIBVA_DRIVER_NAME = "nvidia";
    };

    xdg.portal.enable = true;
    # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
