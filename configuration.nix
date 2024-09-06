# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    ./modules/system/xfce-bspwm.nix
    ./modules/system/system.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nicky = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Nicky Tope";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      gcc
    ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      nicky = import ./home.nix;
    };
  };


  # Install firefox.
  programs.firefox.enable = true;
  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # eww
    polybar
    rofi
    vim
    wget
    font-manager
    feh
    flameshot
    simplescreenrecorder
    xclip
    xorg.xrandr
    libnotify
    xdg-utils
    cmake
    jq
    gimp
    colorpicker
    dunst
    (pass.withExtensions (ext: with ext; [pass-otp]))
    (firefox.override { nativeMessagingHosts = [(passff-host.overrideAttrs (old: { dontStrip = true; patchPhase = ''
sed -i 's#COMMAND = "pass"#COMMAND = "${pass.withExtensions (ext: with ext; [pass-otp])}/bin/pass"#' src/passff.py
''; }))]; })
    gnupg
    pinentry-curses
    pinentry-gtk2
    pinentry-rofi
    python3
    inputs.wezterm.packages.${pkgs.system}.default
  ];

}
