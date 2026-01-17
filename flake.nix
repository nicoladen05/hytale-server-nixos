{
  description = "A NixOS module for the Hytale Server";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

  outputs = { self, nixpkgs }:
  let
    systems = [ "x86_64-linux" "aarch64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in
  {
  packages = forAllSystems ( system:
    let
      pkgs = import nixpkgs { inherit system; };
    in
    {
      hytale-server = pkgs.callPackage ./pkgs/hytale-server { };
    });
  };
}
