{
  lib,
  config,
  pkgs,
  ...
}:

let
  primaryMonitor =
    (builtins.head (builtins.filter (d: d.primary) config.home-manager.hyprland.displays)).display;
in
{
  options = {
    home-manager.waybar.enable = lib.mkEnableOption "enable waybar";
  };

  config = lib.mkIf config.home-manager.waybar.enable {
    # Scripts
    home.packages = with pkgs; [
      (writeShellScriptBin "weather-script" ''
        #!/usr/bin/env bash

        get_weather_icon() {
            local condition="$1"
            case "''${condition,,}" in
                # Sunny
                *☀️*)     echo " " ;; # Sunny
                *🌤️*)     echo " " ;; # Sun, small cloud
                *☀️*)     echo " " ;; # Sun, big cloud
                # Cloudy
                *☁️*)     echo " " ;; # Cloud
                *🌥️*)     echo " " ;; # Sun behind large cloud
                *🌦️*)     echo " " ;; # Sun behind rain cloud
                *🌧️*)     echo " " ;; # Cloud with rain
                # Night
                *☁️*)     echo "" ;; # Moon
                # Percipitation
                *🌨️*)     echo " " ;; # Cloud with snow
                *🌩️*)     echo " " ;; # Cloud with lightning
                *⛈️*)     echo " " ;; # Thunder cloud and rain
                *🌫*)     echo "" ;; # Fog
                *)          echo "$condition" ;;
            esac
        }

        weather=$(curl -s 'wttr.in/?format=1')
        temp=$(echo "$weather" | awk '{print $2}' | sed 's/+//')
        condition=$(echo "$weather" | awk '{print $1}')

        icon=$(get_weather_icon "$condition")

        echo "$icon $temp"
      '')
      (writeShellScriptBin "spotify-status" ''
        #!/usr/bin/env bash

        # If spotify is running, print the current song, otherwise print nothing
        if pgrep -f spotify-wrapped >/dev/null; then
          # When the player 
          playerctl metadata -p spotify --format ' {{ artist }} - {{ title }}'
        fi

        # same for spotify-player
        if pgrep -x spotify_player >/dev/null; then
          playerctl metadata -p spotify_player --format ' {{ artist }} - {{ title }}'
        fi
      '')
    ];

    programs.waybar.enable = true;

    programs.waybar.settings = {
      mainBar = {
        height = 30;
        position = "top";

        output = primaryMonitor;

        modules-left = [ "hyprland/workspaces" ];
        modules-center = [
          "clock"
          "custom/date"
          "custom/weather"
        ];
        modules-right = [
          "privacy"
          "tray"
          "gamemode"
          "network"
          "wireplumber"
        ];

        "hyprland/workspaces" = {
          on-click = "activate";
          format = "{icon}";
          format-icons = {
            default = "";
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
          };
          persistent_workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
          };
        };

        clock = {
          format = "󰥔 {:%H:%M}";
        };

        tray = {
          icon-size = 18;
        };

        "custom/date" = {
          exec = "date +'󰃭 %a, %d. %b'";
          interval = 60;
        };

        "custom/weather" = {
          exec = "weather-script";
          interval = 3600;
        };

        "custom/spotify" = {
          exec = "spotify-status";
          return-type = "empty";
          interval = 5;
        };

        "custom/pomodoro" = {
          exec = "tomato -t";
          return-type = "empty";
          interval = 1;
        };

        cpu = {
          interval = 10;
          format = " {usage}%";
        };

        memory = {
          interval = 30;
          format = " {used}/{total} GB";
        };

        gamemode = {
          format = "{glyph}";
          format-alt = "{glyph} {count}";
          glyph = " ";
          use-icon = false;
          icon-size = 0;
          icon-spacing = 0;
        };

        network = {
          "format-disconnected" = "󰯡 Disconnected";
          "format-ethernet" = "󰈀  Wired";
          "format-linked" = "󰖪 {essid}";
          "format-wifi" = "󰖩 {essid}";
          "format" = "󰈀  Wired";
          "interval" = 5;
          "tooltip" = true;
          "tooltip-format" = "{ipaddr}";
          "tooltip-format-wifi" = "{ipaddr} ({signalStrength}, {frequency})";
        };

        wireplumber = {
          format-icons = {
            headphone = "";
            default = [
              "󰖀"
              "󰕾"
              ""
            ];
          };
          format = "{icon} {volume}%";
          format-muted = "󰝟 {volume}%";
          on-click = "pavucontrol";
          scroll-step = 1;
        };
      };
    };

    programs.waybar.style = lib.mkAfter ''
      * {
        border: none;
        border-radius: 0;
        min-height: 0;
        font-size: 16px;
        font-family: Iosevka NF;
        font-weight: 600;
      }

      window#waybar {
        background-color: rgba(0,0,0,0);
        transition-property: background-color;
        transition-duration: 0.5s;
      }

      .modules-left #workspaces button {
          border-bottom: none;
      }
      .modules-left #workspaces button.focused,
      .modules-left #workspaces button.active {
          border-bottom: none;
      }

      window#waybar.hidden {
        opacity: 0.5;
      }

      #workspaces {
        background-color: @base00;
        margin: 6px 10px 10px 16px;
        padding: 0px 3px;
        border-radius: 11;
        box-shadow: 4px 4px 4px rgba(0, 0, 0, 0.2);
      }

      #workspaces button {
        all: initial;
        min-width: 0;
        box-shadow: none;
        padding: 8px 18px;
        margin: 6px 3px;
        border-radius: 8px;
        background-color: @base02;
        color: @base07;
      }

      #workspaces button.active {
        color: @base00;
        background-color: @base0D;
      }

      #workspaces button:hover {
        box-shadow: none;
        text-shadow: inherit;
        color: @base06;
        background-color: @base03;
      }

      #workspaces button.urgent {
        background-color: @base08;
      }

      .modules-center {
        background-color: @base00;
        margin: 6px 10px 10px 10px;
        padding: 0px 3px;
        border-radius: 11;
        box-shadow: 4px 4px 4px rgba(0, 0, 0, 0.2);
      }

      .modules-right {
        background-color: @base00;
        margin: 6px 16px 10px 10px;
        padding: 0px 3px;
        border-radius: 11;
        box-shadow: 4px 4px 4px rgba(0, 0, 0, 0.2);
      }

      #memory,
      #custom-power,
      #battery,
      #backlight,
      #wireplumber,
      #network,
      #clock,
      #custom-date,
      #custom-weather,
      #custom-spotify,
      #cpu,
      #memory,
      #gamemode,
      #custom-pomodoro,
      #privacy,
      #tray {
        border-radius: 8px;
        margin: 6px 3px;
        padding: 8px 12px;
        background-color: @base02;
        color: @base06;
      }

      #privacy {
        background-color: @base09;
        color: @base02;
      }

      tooltip {
        border-radius: 8px;
        padding: 15px;
        background-color: @base00;
      }

      tooltip label {
        padding: 5px;
        background-color: @base00;
      }
    '';

    services.playerctld.enable = true;
  };
}
