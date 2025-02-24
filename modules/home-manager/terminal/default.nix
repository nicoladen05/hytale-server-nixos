{ config, lib, ... }:

{
  imports = [
    ./alacritty.nix
    ./nerdfonts.nix
    ./tmux.nix
    ./zsh.nix
  ];

  options = {
    terminal.enable = lib.mkEnableOption "terminal environment";
  };

  config = lib.mkIf config.terminal.enable {
    terminal.alacritty.enable = true;
    font.nerd-fonts.enable = true;
    shell.zsh.enable = true;
    terminal.tmux.enable = true;
  };
}
