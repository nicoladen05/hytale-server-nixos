{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/home-manager
    inputs.vicinae.homeManagerModules.default
  ];

  home-manager = {
    enable = true;

    direnv.enable = true;
    zsh.enable = true;
    tmux.enable = true;
    yazi.enable = true;
  };
}
