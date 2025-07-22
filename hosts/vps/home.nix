{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/home-manager
  ];

  home-manager = {
    enable = true;

    zsh.enable = true;
    tmux.enable = true;
    yazi.enable = true;
  };
}
