{ config, pkgs, ... }:

{
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
    stylua
    bat
    ripgrep
    nodejs_20
    lazygit
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.git = {
    enable = true;
    userName = "Nicky Tope";
    userEmail = "nicky.tope@gmail.com";
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita-dark";
      package = pkgs.adwaita-icon-theme;
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.adwaita-icon-theme;
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

  imports = [
    ./modules/user/neovim.nix
    ./modules/user/dotfiles.nix
    ./modules/user/zsh.nix
  ];
}
