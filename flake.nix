{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
    master = import inputs.nixpkgs-master {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    # Original XFCE + bspwm configurations
    nixosConfigurations.mininix = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs unstable master;
      };
      modules = [
        ./hosts/mininix/default.nix
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit inputs unstable master;
          };
          home-manager.users.nicky = import ./users/nicky/xfce-user.nix;
        }
      ];
    };
    nixosConfigurations.nt-oryx-xfce = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs unstable master;
      };
      modules = [
        ./hosts/nt-oryx/default.nix
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit inputs unstable master;
          };
          home-manager.users.nicky = import ./users/nicky/xfce-user.nix;
        }
      ];
    };

    # Hyprland test configurations
    nixosConfigurations.mininix-hyprland = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs unstable master;
      };
      modules = [
        ./hosts/mininix/hyprland.nix
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit inputs unstable master;
          };
          home-manager.users.nicky = {
            imports = [
              ./users/nicky/hyprland-user.nix
              ./users/nicky/hyprland-mininix.nix
            ];
          };
        }
      ];
    };
    nixosConfigurations.nt-oryx = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs unstable master;
      };
      modules = [
        ./hosts/nt-oryx/hyprland.nix
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit inputs unstable master;
          };
          home-manager.users.nicky = {
            imports = [
              ./users/nicky/hyprland-user.nix
              ./users/nicky/hyprland-nt-oryx.nix
            ];
          };
        }
      ];
    };
  };
}
