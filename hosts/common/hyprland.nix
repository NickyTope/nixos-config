{
  pkgs,
  lib,
  ...
}: {
  # Enable Hyprland with UWSM
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # UWSM configuration
  programs.uwsm = {
    enable = true;
    waylandCompositors.hyprland = {
      prettyName = "Hyprland";
      comment = "Hyprland compositor managed by UWSM";
      binPath = "/run/current-system/sw/bin/Hyprland";
    };
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
    wlr.enable = false; # Disable wlr when using Hyprland
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
    config = {
      common = {
        default = ["*"];
        "org.freedesktop.portal.Settings" = ["hyprland"];
        "org.freedesktop.portal.ScreenCast" = ["hyprland"];
        "org.freedesktop.portal.Screenshot" = ["hyprland"];
        "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
        "org.freedesktop.impl.portal.FileChooser" = ["hyprland"];
        "org.freedesktop.portal.OpenURI" = ["hyprland"];
      };
      hyprland = {
        default = ["hyprland"];
      };
    };
  };

  # Security and authentication
  security.pam.services.swaylock = {};
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # Use dbus-broker for better UWSM compatibility
  services.dbus.implementation = "broker";

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
    
    # XDG and Portal integration
    GTK_USE_PORTAL = "1";
    NIXOS_XDG_OPEN_USE_PORTAL = "1";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    
    # QT Wayland integration
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
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

    # File management
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
    file-roller # Archive manager for thunar-archive-plugin

    # XDG and Desktop Integration
    xdg-launch
    xdg-user-dirs
    xdg-dbus-proxy
    desktop-file-utils
    libxdg_basedir
    shared-mime-info
    mime-types

    # Enhanced GTK and QT support
    adwaita-qt
    adwaita-qt6
    gsettings-qt
    libsForQt5.qt5ct
    qt6.qtbase
    qt6.qtwayland
    gtk4-layer-shell
    libappindicator-gtk3
    webkitgtk_6_0
  ];

  # Enable required hardware support
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
