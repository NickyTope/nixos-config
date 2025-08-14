{
  pkgs,
  inputs,
  unstable,
  ...
}: {
  programs.firefox.enable = true;
  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.pathsToLink = ["/share/zsh"];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  nix.settings = {
    # substituters = ["https://wezterm.cachix.org"];
    # trusted-public-keys = ["wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="];
  };

  nix.extraOptions = ''
    extra-substituters = https://devenv.cachix.org
    extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
  '';

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.hurmit
      nerd-fonts.jetbrains-mono
      nerd-fonts.noto
      nerd-fonts._0xproto
      nerd-fonts.fira-code
      nerd-fonts.victor-mono
      roboto-mono
      icomoon-feather
      material-icons
    ];
    fontDir = {
      enable = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    killall
    polybar
    flameshot
    vim
    libreoffice-fresh
    hunspell
    hunspellDicts.en-au-large
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
    libnotify
    cmake
    jq
    gimp
    dunst
    (pass.withExtensions (ext: with ext; [pass-otp pass-update]))
    (firefox.override {
      nativeMessagingHosts = [
        (passff-host.overrideAttrs (old: {
          dontStrip = true;
          patchPhase = ''
            sed -i 's#COMMAND = "pass"#COMMAND = "${pass.withExtensions (ext: with ext; [pass-otp])}/bin/pass"#' src/passff.py
          '';
        }))
      ];
    })
    gnupg
    pinentry-curses
    pinentry-gtk2
    (python3.withPackages (python-pkgs: [
      # select Python packages here
      python-pkgs.pandas
      python-pkgs.requests
      python-pkgs.python-lsp-server
    ]))
    unstable.zoom-us
    slack
    teams-for-linux
    mongodb-compass
    libsecret
    gnome-keyring
    bitwarden-desktop
    qmk
    qmk_hid
    ldns
    btop
    go
    fastfetch
    zathura
    clipcat
    pick-colour-picker
    xournalpp
    oath-toolkit
    openvpn
    expect
    glab
    rclone
    unstable.devenv
  ];

  hardware.keyboard.qmk.enable = true;
}
