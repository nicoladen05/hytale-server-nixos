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

    impermanence.url = "github:nix-community/impermanence";

    sops-nix.url = "github:Mic92/sops-nix";

    deploy-rs.url = "github:serokell/deploy-rs";

    stylix.url = "github:danth/stylix";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-fonts = {
      # url = "github:Lyndeno/apple-fonts.nix";
      url = "github:momo-p/apple-fonts.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      network = import ./configs/network;
    in
    {
      # NixOS Configurations
      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs network; };
        modules = with inputs; [
          ./hosts/desktop/configuration.nix
          impermanence.nixosModules.impermanence
          nur.modules.nixos.default
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          stylix.nixosModules.stylix
          nvf.nixosModules.default
        ];
      };

      nixosConfigurations.vps = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit inputs network; };
        modules = with inputs; [
          ./hosts/vps/configuration.nix
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
          nvf.nixosModules.default
        ];
      };

      nixosConfigurations.server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs network; };
        modules = with inputs; [
          ./hosts/server/configuration.nix
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
          stylix.nixosModules.stylix
          nvf.nixosModules.default
        ];
      };

      # Packages
      packages."x86_64-linux".pycord = pkgs.callPackage ./packages/pycord.nix { };
      packages."x86_64-linux".wavelink = pkgs.callPackage ./packages/wavelink.nix { };

      # DeployRS Nodes
      deploy.nodes.vps = {
        hostname = "130.61.231.173";
        remoteBuild = true;
        interactiveSudo = true;
        profiles.system = {
          user = "root";
          sshUser = "nico";
          path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.vps;
        };
      };

      deploy.nodes.server = {
        hostname = network.clients.server.ip;
        interactiveSudo = true;
        profiles.system = {
          user = "root";
          sshUser = "nico";
          path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.server;
        };
      };
    };
}
