{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wezterm = {
      url = "github:wez/wezterm/main?dir=nix";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    unstable = import inputs.nixpkgs-unstable {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.mininix = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        inherit unstable;
      };
      modules = [
        ./hosts/mininix/default.nix
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            inherit unstable;
          };
          home-manager.users.nicky = import ./users/nicky;
        }
      ];
    };
    nixosConfigurations.nt-oryx = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        inherit unstable;
      };
      modules = [
        ./hosts/nt-oryx/default.nix
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            inherit unstable;
          };
          home-manager.users.nicky = import ./users/nicky;
        }
      ];
    };
  };
}
