{ lib, pkgs, ... }:

{
  imports = [
    ../modules/home-manager/default.nix
    ../modules/nixos/nvf
  ];

  # For easy switching with nh
  home.sessionVariables = {
    NH_FLAKE = "~/dev/nix";
  };

  home-manager = {
    enable = true;
    zsh.enable = true;
    tmux.enable = true;
  };

  # NVF
  nvf.enable = true;
  programs.nvf.settings.vim.theme = {
    enable = true;
    name = "catppuccin";
    style = "mocha";
  };
}
