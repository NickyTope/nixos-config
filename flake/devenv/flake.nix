{
  description = "Modular devenv configurations";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
    devenv.url = "github:cachix/devenv";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
    devenv,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      # Export all modules for inspection
      devenvModules = {
        base = ./modules/base.nix;
        typescript = ./modules/typescript.nix;
        prisma = ./modules/prisma.nix;
        biome = ./modules/biome.nix;
        prettier = ./modules/prettier.nix;
        stylelint = ./modules/stylelint.nix;
        nix = ./modules/nix.nix;
        lua = ./modules/lua.nix;
      };

      devShells = {
        # Individual modules
        typescript = devenv.lib.mkShell {
          inherit pkgs inputs;
          modules = [./modules/base.nix ./modules/typescript.nix];
        };

        # Common combinations
        ts-biome = devenv.lib.mkShell {
          inherit pkgs inputs;
          modules = [
            ./modules/base.nix
            ./modules/typescript.nix
            ./modules/biome.nix
          ];
        };

        ts-prisma-biome = devenv.lib.mkShell {
          inherit pkgs inputs;
          modules = [
            ./modules/base.nix
            ./modules/typescript.nix
            ./modules/biome.nix
            ./modules/prisma.nix
          ];
        };

        ts-prettier = devenv.lib.mkShell {
          inherit pkgs inputs;
          modules = [
            ./modules/base.nix
            ./modules/typescript.nix
            ./modules/prettier.nix
            ./modules/stylelint.nix
          ];
        };

        nix-lua = devenv.lib.mkShell {
          inherit pkgs inputs;
          modules = [
            ./modules/base.nix
            ./modules/nix.nix
            ./modules/lua.nix
            ./combinations/nixos-config.nix
          ];
        };

        default = self.devShells.${system}.typescript-biome;
      };
    });
}
