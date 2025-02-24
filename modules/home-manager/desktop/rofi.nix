{ pkgs, lib, config, ... }:

{
  options = {
    rofi.enable = lib.mkEnableOption "enables rofi";
  };

  config = lib.mkIf config.rofi.enable {

    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      location = "center";
      theme = {
        "*" = {
          margin = 2;
          padding = 2;
          spacing = 2;
        };

        "element-icon, element-text, scrollbar" = {
          cursor = "pointer";
        };

        window = {
          location = "northwest";
          width = 400;
          x-offset = 4;
          y-offset = 26;
          border = 1;
          border-radius = 6;
        };

        inputbar = {
          spacing = 8;
          padding = "4px 8px";
          children = [ "entry" ];
        };

        "icon-search, entry, element-icon, element-text" = {
          vertical-align = "0.5";
        };

        icon-search = {
          expand = false;
          filename = "search-symbolic";
          size = 14;
        };

        textbox = {
          padding = "4px 8px";
        };

        listview = {
          padding = "4px 0px";
          lines = 12;
          columns = 1;
          scrollbar = false;
          fixed-height = false;
          dynamic = true;
        };

        element = {
          padding = "4px 8px";
          spacing = 8;
        };

        "element normal urgent" = {
          text-color = "@urgent";
        };

        "element normal active" = {
          text-color = "@accent";
        };

        "element alternate active" = {
          text-color = "@accent";
        };

        "element selected" = {
          text-color = "@bg1";
          background-color = "@accent";
          radius = 6;
        };

        "element selected urgent" = {
          background-color = "@urgent";
        };

        "element-icon" = {
          size = "0.8em";
        };

        scrollbar = {
          handle-width = 4;
          padding = "0 4px";
        };
      };
    };
  };
}
