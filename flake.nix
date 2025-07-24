{
  description = "Nixos config flake";

  nixConfig = {
    extra-substituters = [
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

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

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
    };

    nixos-raspberrypi = {
      url = "github:nvmd/nixos-raspberrypi/main";
    };

    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    {
      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/desktop/configuration.nix
          inputs.nur.modules.nixos.default
          inputs.home-manager.nixosModules.home-manager
          inputs.sops-nix.nixosModules.sops
          inputs.stylix.nixosModules.stylix
          inputs.nvf.nixosModules.default
          inputs.jovian.nixosModules.default
        ];
      };

      nixosConfigurations.vps = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/vps/configuration.nix
          inputs.disko.nixosModules.disko
          inputs.sops-nix.nixosModules.sops
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          inputs.nvf.nixosModules.default
          inputs.jovian.nixosModules.default
        ];
      };

      # Configuration for homemanager only
      # homeConfigurations."nico" = inputs.home-manager.lib.homeManagerConfiguration {
      #   pkgs = nixpkgs.legacyPackages.aarch64-linux;
      #   modules = [
      #     ./hosts/dev-server/home.nix
      #     inputs.nvf.homeManagerModules.default
      #     inputs.stylix.homeManagerModules.stylix
      #   ];
      #   extraSpecialArgs = {
      #     userName = "nico";
      #   };
      # };

      # nixosConfigurations.rpi5 = nixos-raspberrypi.lib.nixosSystemFull {
      #   system = "aarch64-linux";
      #   specialArgs = { inherit inputs; };
      #   modules = [
      #     ./hosts/rpi5/configuration.nix
            # inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.base
            # inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.bluetooth
      #     inputs.sops-nix.nixosModules.sops
      #   ];
      # };

      deploy.nodes.vps = {
        hostname = "130.61.231.173";
        interactiveSudo = true;
        profiles.system = {
          user = "root";
          sshUser = "nico";
          path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.vps;
        };
      };

      # deploy.nodes.rpi5 = {
      #   hostname = "rpi5";
      #   interactiveSudo = true;
      #   profiles.system = {
      #     user = "root";
      #     sshUser = "nico";
      #     path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.rpi5;
      #   };
      # };
    };
}
