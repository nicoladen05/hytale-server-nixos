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

    disko.url = "github:nix-community/disko";

    sops-nix.url = "github:Mic92/sops-nix";

    deploy-rs.url = "github:serokell/deploy-rs";

    stylix.url = "github:danth/stylix";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-fonts = {
      url = "github:Lyndeno/apple-fonts.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    {
      # NixOS Configurations
      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = with inputs; [
          ./hosts/desktop/configuration.nix
          nur.modules.nixos.default
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          stylix.nixosModules.stylix
          nvf.nixosModules.default
        ];
      };

      nixosConfigurations.vps = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit inputs; };
        modules = with inputs; [
          ./hosts/vps/configuration.nix
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
          nvf.nixosModules.default
        ];
      };

      nixosConfigurations.lxc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/lxc/configuration.nix
        ];
      };

      # DeployRS Nodes
      deploy.nodes.vps = {
        hostname = "130.61.231.173";
        interactiveSudo = true;
        profiles.system = {
          user = "root";
          sshUser = "nico";
          path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.vps;
        };
      };


      deploy.nodes.lxc = {
        hostname = "192.168.2.53";
        profiles.system = {
          user = "root";
          path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.lxc;
        };
      };
    };
}
