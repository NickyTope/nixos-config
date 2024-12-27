{
  config,
  pkgs,
  inputs,
  unstable,
  ...
}: let
  lsp = pkgs.callPackage ../../derivations/bun-lsp.nix;
in {
  # Install firefox.
  programs.firefox.enable = true;
  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.pathsToLink = ["/share/zsh"];

  nix.settings = {
    substituters = ["https://wezterm.cachix.org"];
    trusted-public-keys = ["wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="];
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      (nerdfonts.override {fonts = ["Hermit" "JetBrainsMono" "Noto"];})
      fira-code-nerdfont
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
    # eww
    killall
    polybar
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
    zed-editor
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
    inputs.ghostty.packages.${pkgs.system}.default
  ];

  hardware.keyboard.qmk.enable = true;
}
