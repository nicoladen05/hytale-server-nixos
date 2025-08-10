{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/home-manager
  ];

  services.udiskie = {
    enable = true;
    settings = {
      program_options = {
        file_manager = "${pkgs.pcmanfm}/bin/pcmanfm";
      };
    };
  };

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
          vrr = false;
        }
        {
          display = "HDMI-A-2";
          resolution = "1920x1080";
          offset = "-1080x0";
          refreshRate = 75;
          rotate = 3;
        }
      ];
    };
  };
}
