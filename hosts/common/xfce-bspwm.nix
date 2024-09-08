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

  services = {
    picom = {
      enable = true;
      fade = true;
      shadow = true;
      fadeDelta = 4;
    };
  };



  environment.systemPackages = with pkgs; [
    xorg.xrandr
    bspwm
    sxhkd
    xdotool
  ];

}

