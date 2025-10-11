{ lib, pkgs, ... }:

{
    imports = [
        (../modules/home-manager/default.nix { userName = "nico"; })
    ];
    
    home-manager = {
        enable = true;
    };
}