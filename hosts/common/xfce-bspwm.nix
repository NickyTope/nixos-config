{ pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the XFCE Desktop Environment.
  services.xserver.displayManager.lightdm = {
    enable = true;
    background = pkgs.nixos-artwork.wallpapers.binary-red.gnomeFilePath;
    greeters.slick.enable = true;
  };
  services.xserver.desktopManager.xfce.enable = true;

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
      shadow = true;
      fadeDelta = 4;
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  environment.systemPackages = with pkgs; [
    xorg.xrandr
    bspwm
    sxhkd
    xdotool
    qt5ct
    dracula-qt5-theme
    xclip
    xcolor
    xorg.xrandr
    xdg-utils
    pavucontrol
    xorg.xbacklight
  ];

}

