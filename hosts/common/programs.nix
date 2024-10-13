{ config, pkgs, inputs, ... }:

{

  # Install firefox.
  programs.firefox.enable = true;
  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.pathsToLink = [ "/share/zsh" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # eww
    killall
    polybar
    rofi
    rofi-emoji
    colorpicker
    flameshot
    vim
    libreoffice
    meld
    volumeicon
    pw-volume
    maim
    wget
    font-manager
    feh
    fzf
    flameshot
    simplescreenrecorder
    fuchsia-cursor
    libnotify
    cmake
    jq
    gimp
    colorpicker
    dunst
    (pass.withExtensions (ext: with ext; [pass-otp pass-update]))
    (firefox.override { nativeMessagingHosts = [(passff-host.overrideAttrs (old: { dontStrip = true; patchPhase = ''
sed -i 's#COMMAND = "pass"#COMMAND = "${pass.withExtensions (ext: with ext; [pass-otp])}/bin/pass"#' src/passff.py
''; }))]; })
    gnupg
    pinentry-curses
    pinentry-gtk2
    (python3.withPackages (python-pkgs: [
      # select Python packages here
      python-pkgs.pandas
      python-pkgs.requests
    ]))
    inputs.wezterm.packages.${pkgs.system}.default
    zoom-us
    slack
    mongodb-compass
    zed-editor
    qmk
    qmk_hid
    btop
  ];

  hardware.keyboard.qmk.enable = true;

}
