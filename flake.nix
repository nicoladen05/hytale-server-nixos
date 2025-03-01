{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-fonts = {
     url = "github:Lyndeno/apple-fonts.nix";
     inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
    };

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
    };

    raspberry-pi-nix = {
      url = "github:nix-community/raspberry-pi-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      secrets = builtins.fromJSON (builtins.readFile ./secrets/secrets.json);
    in {
      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs; inherit secrets;};
        modules = [
          ./hosts/desktop/configuration.nix
          inputs.nur.modules.nixos.default
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = { inherit secrets; };
          }
          inputs.stylix.nixosModules.stylix
          inputs.nvf.nixosModules.default
        ];
      };

      nixosConfigurations.rpi5 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {inherit inputs; inherit secrets;};
        modules = [
          ./hosts/rpi5/configuration.nix
        ];
      };
    };
}
