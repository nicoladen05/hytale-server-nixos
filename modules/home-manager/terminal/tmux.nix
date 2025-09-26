{
  lib,
  config,
  pkgs,
  ...
}:

let
  tmuxSessionizer = pkgs.fetchFromGitHub {
    owner = "ThePrimeagen";
    repo = "tmux-sessionizer";
    rev = "7edf8211e36368c29ffc0d2c6d5d2d350b4d729b";
    sha256 = "sha256-4QGlq/cLbed7AZhQ3R1yH+44gmgp9gSzbiQft8X5NwU=";
  };
in
{
  options = {
    home-manager.tmux.enable = lib.mkEnableOption "enable tmux";
  };

  config = lib.mkIf config.home-manager.tmux.enable {
    home.packages = with pkgs; [
      fzf
      (writeShellScriptBin "tmux-sessionizer" ''
        exec ${tmuxSessionizer}/tmux-sessionizer "$@"
      '')
    ];

    home.file.".config/tmux-sessionizer/tmux-sessionizer.conf".text = ''
      TS_EXTRA_SEARCH_PATHS=(~/.config/:1 ~/dev:1 ~/docs:2)
    '';

    stylix.targets.tmux.enable = false;

    programs.tmux = {
      enable = true;
      clock24 = true;
      shortcut = "space";
      mouse = true;
      keyMode = "vi";
      escapeTime = 0;
      baseIndex = 1;
      customPaneNavigationAndResize = true;
      disableConfirmationPrompt = true;

      plugins = with pkgs; [
        tmuxPlugins.fingers
        {
          plugin = tmuxPlugins.fingers;
        }
      ];

      extraConfig = ''
        set -g default-terminal "tmux-256color"
        set -as terminal-overrides ",alacritty*:Tc"
        set-environment -g COLORTERM "truecolor"

        set -g status-position top

        set -g status-style bg=default,fg=default

        set -g automatic-rename on

        set -g pane-border-status off

        set -g status-right " #[bg=blue,fg=black] %a, %d.%m. %H:%M #[default]"
        set -g status-left "#[bg=blue,fg=black] #S#{?window_zoomed_flag, 󰊓,} #[default]"

        set -g window-status-format " #I: #{=10:window_name} "
        set -g window-status-current-format " #I: #{=10:window_name} "

        set -g window-status-current-style fg=black,bg=green

        set -g window-status-style fg=white,dim

        unbind h
        unbind n
        unbind e
        unbind i

        bind h select-pane -L
        bind n select-pane -D
        bind e select-pane -U
        bind i select-pane -R
      '';
    };
  };
}
