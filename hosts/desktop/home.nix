{ config, pkgs, inputs, secrets, ... }:

{
  imports = [
    ../../modules/home-manager
  ];

  home-manager = {
    enable = true;

    firefox.enable = true;
    terminal.enable = true;
    yazi.enable = true;
    zathura.enable = true;

    hyprland = {
      enable = true;
      displays = [
        {
          display = "DP-6";
          primary = true;
          resolution = "2560x1440";
          refreshRate = 165;
          vrr = true;
        }
        {
          display = "HDMI-A-2";
          resolution = "1920x1080";
          refreshRate = 75;
          offset = "-1080x0";
          rotate = 3; # Rotate CCW
        }
      ];
    };
  };

  

}
