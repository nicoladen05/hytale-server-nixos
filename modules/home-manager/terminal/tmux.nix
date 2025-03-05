{ lib, config, pkgs, inputs, ... }:


# let
#   minimal-tmux-status = pkgs.tmuxPlugins.mkTmuxPlugin {
#       pluginName = "minimal-tmux-status";
#       version = "v1.0.0";
#       src = pkgs.fetchFromGitHub {
#         owner = "niksingh710";
#         repo = "minimal-tmux-status";
#         rev = "d7188c1aeb1c7dd03230982445b7360f5e230131";
#         sha256 = "JtbuSxWFR94HiUdQL9uIm2V/kwGz0gbVbqvYWmEncbc=";
#       };
#     };
# in
{
  options = {
    home-manager.tmux.enable = lib.mkEnableOption "enable tmux";
  };

  config = lib.mkIf config.home-manager.tmux.enable {
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
        set -g default-terminal "xterm-256color"
        set -ga terminal-overrides ",*256col*:Tc"
        set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
        set-environment -g COLORTERM "truecolor"

        set -g status-position top

        set -g status-style bg=default,fg=default

        set -g automatic-rename off
        set -g window-status-current-format "#I:#W"
        set -g window-status-format "#I:#W"

        set -g pane-border-status off

        set -g status-right "%d.%m. %H:%M"
        set -g status-left ""

        set -g window-status-format "#I: #{=10:window_name} "
        set -g window-status-current-format "#I: #{=10:window_name} "

        set -g window-status-current-style fg=white,bg="white"

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
