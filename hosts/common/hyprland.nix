{pkgs, ...}: {
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Enable required services for Wayland
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # XDG Desktop Portal for Wayland
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = pkgs.lib.mkForce ["hyprland" "gtk"];
      };
    };
  };

  # Security and authentication
  security.pam.services.swaylock = {};
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # Fonts for Wayland
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
    ];
  };

  # Environment variables for Wayland
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  # Additional packages needed for Hyprland
  environment.systemPackages = with pkgs; [
    # Wayland utilities
    wlroots
    xwayland
    waybar

    # Session management
    gtklock

    # Clipboard and file operations
    wl-clipboard
    xdg-utils

    # Hardware control
    brightnessctl

    # Audio control
    pavucontrol
    ponymix
  ];

  # Enable required hardware support
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
