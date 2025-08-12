{
  pkgs,
  lib,
  ...
}: {
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path = "/etc/regreet/background.jpg";
        fit = "Cover";
      };
      GTK = {
        application_prefer_dark_theme = true;
        cursor_theme_name = lib.mkForce "BreezeX-RosePine-Linux";
      };
      widget.clock = {
        timezone = "Australia/Hobart";
      };
    };
  };

  # Enable required services for Wayland
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.cage}/bin/cage -s -mlast -- ${pkgs.greetd.regreet}/bin/regreet";
        user = "greeter";
      };
    };
  };

  # Copy background image to system location
  environment.etc."regreet/background.jpg".source = ../../assets/regreet-background.jpg;

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
    GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}";
  };

  # Additional packages needed for Hyprland
  environment.systemPackages = with pkgs; [
    # Wayland utilities
    wlroots
    xwayland
    waybar
    cage # Compositor for regreet

    # Session management
    gtklock

    # GTK for regreet
    gtk3
    gtk4
    glib
    gsettings-desktop-schemas

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
