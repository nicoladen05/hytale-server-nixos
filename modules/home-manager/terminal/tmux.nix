{ lib, config, pkgs, ... }:


let
  tmux-pomodoro = pkgs.tmuxPlugins.mkTmuxPlugin {
      pluginName = "tmux-pomodoro-plus";
      version = "v1.0.2";
      src = pkgs.fetchFromGitHub {
        owner = "olimorris";
        repo = "tmux-pomodoro-plus";
        rev = "bb136e7372b29cbd5e6909f4dd9814fa0ec13a49";
        sha256 = "1i709pspa2q7mn1pfqkyvvziqi0g4i45rdfgj97d5jzrhra3q9jm";
      };
    };
in
{
  options = {
    home-manager.tmux.enable = lib.mkEnableOption "enable tmux";
  };

  config = lib.mkIf config.terminal.tmux.enable {
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
        # {
        #   plugin = tmux-pomodoro;
        # }
      ];

      extraConfig = ''
        set -g default-terminal "xterm-256color"
        set -ga terminal-overrides ",*256col*:Tc"
        set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
        set-environment -g COLORTERM "truecolor"

        set -g status-bg black

        set -g status-right ' %H:%M'

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
