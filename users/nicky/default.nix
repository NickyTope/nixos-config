{ config, pkgs, lib, ... }:

{
  imports = [
    ./zsh.nix
    ./neovim.nix
    ./wezterm.nix
    ./dotfiles.nix
  ];

  home.username = "nicky";
  home.homeDirectory = "/home/nicky";
  home.stateVersion = "24.11";
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = ["Hermit" "JetBrainsMono" "Noto" ]; })
    fira-code
    roboto-mono
    icomoon-feather
    material-icons
    bat
    ripgrep
    nodejs_20
    lazygit
    stylua
    lua-language-server
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "Nicky Tope";
    userEmail = "nicky.tope@gmail.com";
  };

  gtk = {
    enable = true;
    cursorTheme = {
      name = "Fuchsia";
      package = pkgs.fuchsia-cursor;
    };
    iconTheme = {
      name = "Dracula";
      package = pkgs.dracula-icon-theme;
    };
    theme = {
      name = "Nightfox-Dark";
      package = pkgs.nightfox-gtk-theme;
    };
  };

  # Screen lock
  services = {
    screen-locker = {
      enable = true;
      inactiveInterval = 10;
      lockCmd = "${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 10 15";
    };

    # Auto mount devices
    udiskie = {
      enable = true;
    };
  };

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfreePredicate = (pkg: true);

}
