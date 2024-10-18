{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    wezterm = {
      url = "github:wez/wezterm/main?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.mininix = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/mininix/default.nix
        inputs.home-manager.nixosModules.default
      ];
    };
    nixosConfigurations.nt-oryx = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/nt-oryx/default.nix
        inputs.home-manager.nixosModules.default
      ];
    };
  };
}
