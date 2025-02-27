{ pkgs, lib, ... }:

{
  imports = [
    ./desktop
    ./gaming
    ./system
    
    ./nvf.nix
    ./packages.nix
  ];
}
