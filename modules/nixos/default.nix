{ pkgs, lib, ... }:

{
  imports = [
    ./desktop
    ./gaming
    ./system
    ./nvf
    ./programs

    ./packages.nix
  ];
}
