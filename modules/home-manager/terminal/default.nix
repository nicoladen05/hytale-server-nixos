{ config, lib, ... }:

{
  imports = [
    ./alacritty.nix
    ./ghostty.nix
    ./neomutt.nix
    ./nerdfonts.nix
    ./tmux.nix
    ./zsh.nix
  ];

  options = {
    home-manager.terminal.enable = lib.mkEnableOption "terminal environment";
  };

  config = lib.mkIf config.home-manager.terminal.enable {
    home-manager.alacritty.enable = false;
    home-manager.ghostty.enable = true;
    home-manager.nerd-fonts.enable = true;
    home-manager.zsh.enable = true;
    home-manager.tmux.enable = true;
  };
}
