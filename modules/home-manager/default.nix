{ pkgs, lib, secrets, ... }:

{
  imports =
    [
      ./desktop
      ./terminal
      ./apps
    ];
}
