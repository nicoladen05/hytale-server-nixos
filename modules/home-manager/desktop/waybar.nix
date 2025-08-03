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
        height = 26;
        spacing = 0;
        position = "top";
        layer = "top";

        output = primaryMonitor;

        modules-left = [ "hyprland/workspaces" ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "group/tray-expander"
          "gamemode"
          "bluetooth"
          "network"
          "pulseaudio"
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
            "active" = "󱓻";
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
          format = "{:%A %H:%M}";
          format-alt = "{:%d %B W%V %Y}";
          tooltip = false;
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
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          format = "{icon}";
          format-wifi = "{icon}";
          format-ethernet = "󰀂";
          format-disconnected = "󰖪";
          tooltip-format-wifi = "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-disconnected = "Disconnected";
          interval = 3;
        };

        bluetooth = {
          format = "";
          format-disabled = "󰂲";
          format-connected = "";
          tooltip-format = "Devices connected: {num_connections}";
        };

        pulseaudio = {
          format = "{icon}";
          on-click = "";
          on-click-right = "pamixer -t";
          tooltip-format = "Playing at {volume}%";
          scroll-step = 5;
          format-muted = "󰝟";
          format-icons = {
            default = [
              ""
              ""
              ""
            ];
          };
        };

        "group/tray-expander" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 600;
            children-class = "tray-group-item";
          };
          modules = [
            "custom/expand-icon"
            "tray"
          ];
        };
        "custom/expand-icon" = {
          format = " ";
          tooltip = false;
        };
        tray = {
          icon-size = 16;
          spacing = 16;
        };
      };
    };

    programs.waybar.style = lib.mkAfter ''
        * {
          background-color: @base00;
          color: @base07;

          border: none;
          border-radius: 0;
          min-height: 0;
          font-family: Iosevka NF;
          font-size: 16px;
        }

      .modules-left {
        margin-left: 8px;
      }

      .modules-right {
        margin-right: 8px;
      }

      #workspaces button {
        all: initial;
        padding: 0 6px;
        margin: 0 1.5px;
        min-width: 9px;
      }

      #workspaces button.empty {
        opacity: 0.5;
      }

      #tray,
      #cpu,
      #battery,
      #network,
      #bluetooth,
      #pulseaudio,
      #clock,
      #custom-power-menu {
        min-width: 12px;
        margin: 0 7.5px;
      }

      #custom-expand-icon {
        margin-right: 12px;
      }

      tooltip {
        padding: 2px;
      }
    '';

    services.playerctld.enable = true;
  };
}
