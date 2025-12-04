{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.vicinae.homeManagerModules.default
    ../../modules/home-manager
  ];


  home-manager = {
    enable = true;

    firefox.enable = true;
    terminal.enable = true;
    yazi.enable = true;
    zathura.enable = true;

    hyprland = {
      enable = false;
      displays = [
        {
          display = "DP-6";
          primary = true;
          resolution = "2560x1440";
          refreshRate = 165;
        }
        {
          display = "HDMI-A-2";
          resolution = "1920x1080";
          offset = "-1080x0";
          refreshRate = 75;
          rotate = 3;
          vrr = true;
        }
      ];
    };
  };
}
