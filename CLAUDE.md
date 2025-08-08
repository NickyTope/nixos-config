# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a NixOS configuration repository using Nix Flakes to manage system configurations for multiple hosts. The configuration uses Home Manager for user-specific settings and SOPS for secret management.

## Key Commands

### System Management
- `sudo nixos-rebuild switch --flake .#<hostname>` - Apply system configuration
- `sudo nixos-rebuild switch --flake .#mininix` - Apply config for mininix host (Hyprland - DEFAULT)
- `sudo nixos-rebuild switch --flake .#nt-oryx` - Apply config for nt-oryx host (Hyprland - DEFAULT)
- `sudo nixos-rebuild switch --flake .#mininix-xfce` - Apply legacy XFCE + bspwm config for mininix
- `sudo nixos-rebuild switch --flake .#nt-oryx-xfce` - Apply legacy XFCE + bspwm config for nt-oryx
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
  - `mininix` - Hyprland (Wayland) configuration (DEFAULT)
  - `mininix-xfce` - Legacy XFCE + bspwm configuration
- **nt-oryx**: System76 laptop with Nvidia GPU, TLP power management
  - `nt-oryx` - Hyprland (Wayland) configuration (DEFAULT)
  - `nt-oryx-xfce` - Legacy XFCE + bspwm configuration

### User Configuration
The `users/nicky/` directory contains modular Home Manager configurations:
- `hyprland-user.nix` - Main user configuration for Hyprland (DEFAULT)
- `xfce-user.nix` - Legacy user configuration for XFCE + bspwm
- `hyprland.nix` - Hyprland window manager configuration
- `hyprland-mininix.nix` - Desktop-specific Hyprland settings
- `hyprland-nt-oryx.nix` - Laptop-specific Hyprland settings
- `waybar.nix` - Waybar configuration with host-specific settings
- `neovim.nix` - Neovim configuration and plugins
- `theme.nix` - GTK and system theming
- `secrets.nix` - Encrypted user secrets
- Individual program configs (ghostty, rofi, zsh, etc.)

### Configuration Management
- **Hyprland**: Modern Wayland compositor with Nightfox theme integration
- **Waybar**: Status bar with host-specific configuration via Home Manager
- **Legacy dotfiles**: Stored in `dotfiles/` directory for XFCE/bspwm compatibility
- **Home Manager**: Declarative user environment management

## Important Files
- `flake.nix:41-62` - mininix system configuration (Hyprland default)
- `flake.nix:120` - nt-oryx system configuration (Hyprland default)
- `hosts/common/hyprland.nix` - Shared Hyprland system settings
- `users/nicky/hyprland-user.nix` - Main Hyprland user configuration
- `users/nicky/waybar.nix` - Host-specific Waybar configuration

## Development Notes
- **Default environment**: Hyprland (Wayland) with Nightfox theming
- **Legacy support**: XFCE + bspwm available via `-xfce` configurations
- **Host-specific features**: 
  - Waybar automatically adapts to desktop vs laptop (battery module)
  - Monitor configuration per host
  - Hardware-specific optimizations
- **Migration complete**: Hyprland is now the primary desktop environment
- **Theme consistency**: Nightfox colors throughout Hyprland, Waybar, terminals, and editors