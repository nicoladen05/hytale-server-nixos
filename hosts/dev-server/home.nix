{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/home-manager
    ../../modules/nixos/nvf.nix
  ];

  home-manager = {
    enable = true;

    tmux.enable = true;
    zsh.enable = true;
  };

  nvf.enable = true;

  stylix = {
    enable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
  };
}
