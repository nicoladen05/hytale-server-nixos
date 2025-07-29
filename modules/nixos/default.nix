{ pkgs, lib, ... }:

{
  imports = [
    ./desktop
    ./gaming
    ./system
    ./nvf

    ./packages.nix
  ];
}
