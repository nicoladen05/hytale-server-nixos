{ lib, config, ... }:

{
  options = {
    home-manager.zsh.enable = lib.mkEnableOption "Enable the zsh shell";
  };

  config = lib.mkIf config.home-manager.zsh.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;

      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ls = "eza --icons";
        ll = "eza -l --icons";

        v = "nvim";
        lg = "lazygit";
        y = "yazi";
        sp = "spotify_player";

        shell = "nix-shell --command zsh -p";

        rb = "sudo nixos-rebuild switch --flake ~/.config/nixos/#default";
        rt = "sudo nixos-rebuild test --flake ~/.config/nixos/#default";
      };

      profileExtra = ''
        if uwsm check may-start; then
            exec uwsm start hyprland.desktop
        fi
      '';
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
