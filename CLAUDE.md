# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a NixOS configuration repository using Nix Flakes to manage system configurations for multiple hosts. The configuration uses Home Manager for user-specific settings and SOPS for secret management.

## Key Commands

### System Management
- `sudo nixos-rebuild switch --flake .#<hostname>` - Apply system configuration
- `sudo nixos-rebuild switch --flake .#mininix` - Apply config for mininix host (XFCE + bspwm)
- `sudo nixos-rebuild switch --flake .#nt-oryx` - Apply config for nt-oryx host (Hyprland - DEFAULT)
- `sudo nixos-rebuild switch --flake .#mininix-hyprland` - Apply Hyprland config for mininix
- `./switch-wm.sh [xfce|hyprland] [hostname]` - Easy window manager switching
- `nix flake update` - Update flake inputs
- `nix-collect-garbage -d` - Clean up old generations

### Secret Management
- `sops users/nicky/secrets.yaml` - Edit user secrets
- `sops hosts/common/secrets.yaml` - Edit system secrets
- Age key should be in `$HOME/.config/sops/age/keys.txt`

### Development Environment
- `nix develop` - Enter development shell (if devenv is configured)
- `direnv allow` - Enable direnv for the project

## Architecture

### Directory Structure
```
├── flake.nix              # Main flake configuration
├── hosts/                 # Host-specific configurations
│   ├── common/           # Shared system configuration
│   ├── mininix/          # Desktop system (AMD GPU)
│   └── nt-oryx/          # Laptop system (System76, Nvidia GPU)
├── users/                # User-specific configurations
│   └── nicky/           # Home Manager configuration
├── dotfiles/            # Configuration files for various programs
│   ├── bspwm/          # Window manager config
│   ├── polybar/        # Status bar config
│   ├── nvim/           # Neovim configuration
│   └── rofi/           # Application launcher
└── files/              # Additional configuration files
```

### System Architecture
- **Flake-based configuration**: Uses Nix Flakes for reproducible builds
- **Multi-host support**: Two configured hosts (mininix, nt-oryx)
- **Home Manager integration**: User configurations managed through Home Manager
- **SOPS encryption**: Secrets encrypted using SOPS with Age keys
- **Modular design**: Configuration split into logical modules for maintainability

### Host Configurations
- **mininix**: Desktop system with AMD GPU, Synergy server enabled
  - `mininix` - XFCE + bspwm configuration
  - `mininix-hyprland` - Hyprland (Wayland) configuration
- **nt-oryx**: System76 laptop with Nvidia GPU, TLP power management
  - `nt-oryx` - Hyprland (Wayland) configuration (DEFAULT)

### User Configuration
The `users/nicky/` directory contains modular Home Manager configurations:
- `default.nix` - Main user configuration for XFCE + bspwm
- `hyprland-user.nix` - User configuration variant for Hyprland
- `hyprland.nix` - Hyprland-specific window manager configuration
- `dotfiles.nix` - Links dotfiles to XDG config locations (XFCE/bspwm only)
- `neovim.nix` - Neovim configuration and plugins
- `theme.nix` - GTK and system theming
- `secrets.nix` - Encrypted user secrets
- Individual program configs (ghostty, rofi, zsh, etc.)

### Dotfiles Management
Dotfiles are stored in the `dotfiles/` directory and symlinked via Home Manager. Key configurations include:
- **bspwm**: Tiling window manager with custom scripts
- **polybar**: Status bar with modules for system monitoring
- **nvim**: Lua-based Neovim configuration with lazy.nvim
- **rofi**: Application launcher with custom themes

## Important Files
- `flake.nix:45-61` - mininix system configuration
- `flake.nix:62-78` - nt-oryx system configuration
- `hosts/common/default.nix` - Shared system settings
- `users/nicky/default.nix` - Main user configuration entry point

## Development Notes
- The configuration uses both stable (25.05) and unstable Nixpkgs channels
- Secrets are managed with SOPS and require proper Age key setup
- Two window manager setups available:
  - **XFCE + bspwm**: Traditional X11 setup with tiling window manager
  - **Hyprland**: Modern Wayland compositor with similar keybindings
- Custom scripts are located in `dotfiles/bspwm/` and `dotfiles/polybar/scripts/`
- Hyprland configuration maps all sxhkd keybindings to equivalent Hyprland binds
- Use `./switch-wm.sh` for easy switching between window managers with rollback capability