{
  pkgs,
  lib,
  config,
  ...
}: {
  languages.nix.enable = true;

  packages = with pkgs; [
    nix
    nixd
    alejandra
    nix-tree
    nix-diff
    statix
    deadnix
    manix
  ];

  scripts = {
    fmt-nix.exec = ''
      echo "🎨 Formatting Nix files with alejandra..."
      find . -name "*.nix" -not -path "./result*" | xargs alejandra
    '';

    lint-nix.exec = ''
      echo "🔍 Linting Nix files..."
      statix check .
      deadnix .
    '';

    check-flake.exec = ''
      echo "✅ Checking flake..."
      nix flake check
    '';

    nixos-switch.exec = ''
      echo "🔄 Building and switching NixOS configuration..."
      sudo nixos-rebuild switch --flake .
    '';

    nixos-build.exec = ''
      echo "🔨 Building NixOS configuration..."
      nixos-rebuild build --flake .
    '';
  };

  scripts.nix-welcome.exec = ''
    echo "❄️  Nix development environment ready!"
    echo "Tools: nixd (LSP), alejandra (fmt), statix (lint)"
  '';

  enterShell = lib.mkAfter ''
    nix-welcome
  '';
}
