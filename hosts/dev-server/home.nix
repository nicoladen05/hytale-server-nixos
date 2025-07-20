{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../modules/home-manager
  ];

  home-manager = {
    enable = true;
  };
}
