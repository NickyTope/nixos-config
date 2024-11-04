{pkgs, ...}: {
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the XFCE Desktop Environment.
  services.xserver.displayManager.lightdm = {
    enable = true;
    background = pkgs.nixos-artwork.wallpapers.binary-red.gnomeFilePath;
    greeters.slick = {
      enable = true;
      cursorTheme = {
        name = "Fuchsia";
        package = pkgs.fuchsia-cursor;
        size = 16;
      };
    };
  };
  services.xserver.desktopManager.xfce = {
    enable = true;
    enableScreensaver = false;

    # better work out how to autostart bspwm first!
    # enableXfwm = false;
    # noDesktop = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.gnome.gnome-keyring.enable = true;

  services = {
    picom = {
      enable = true;
      fade = true;
      shadow = false;
      fadeDelta = 4;
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-xapp
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = ["gtk"];
      };
    };
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
  };

  programs.file-roller.enable = true;

  environment.systemPackages = with pkgs; [
    xorg.xrandr
    bspwm
    sxhkd
    xdotool
    dracula-qt5-theme
    xclip
    xcolor
    xorg.xrandr
    xdg-utils
    pavucontrol
    xorg.xbacklight
    i3lock-fancy-rapid
  ];
}
