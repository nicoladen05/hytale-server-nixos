{ pkgs, lib, config, ... }:

{
  options = {
    home-manager.gnome.enable = lib.mkEnableOption "Enable GNOME settings";
  };

  config = lib.mkIf config.home-manager.gnome.enable {
    dconf = {
      enable = true;
      settings."org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          blur-my-shell.extensionUuid
          dash-to-dock.extensionUuid
        ];
      };
    };
  };
}
