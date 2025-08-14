{
  pkgs,
  unstable,
  ...
}: {
  imports = [
    ./cliphist.nix
    ./cloud.nix
    ./dunst.nix
    ./ghostty.nix
    ./mongodb-compass.nix
    ./neovim.nix
    ./nodejs.nix
    ./openai.nix
    ./rofi.nix
    ./secrets.nix
    ./theme.nix
    ./zsh.nix
    ./hyprland.nix
    ./waybar.nix
  ];

  home.username = "nicky";
  home.homeDirectory = "/home/nicky";
  home.stateVersion = "24.11";
  fonts = {
    fontconfig.enable = true;
  };
  home.packages = with pkgs; [
    bat
    unstable.affine
    wl-screenrec

    # Hyprcursor for improved Wayland cursor theming
    hyprcursor
    rose-pine-hyprcursor
    rose-pine-cursor
    rose-pine-gtk-theme
    rose-pine-icon-theme
  ];

  home.file.".local/share/applications/affine.desktop".text = ''
    [Desktop Entry]
    Name=AFFiNE
    Comment=Affine
    Exec=affine %U
    Icon=affine
    Terminal=false
    Type=Application
    Categories=Utility;
    MimeType=x-scheme-handler/affine;
  '';

  home.file.".local/share/applications/teams-for-linux.desktop".text = ''
    [Desktop Entry]
    Name=Teams for Linux
    Comment=Microsoft Teams
    Exec=teams-for-linux
    Icon=teams-for-linux
    Terminal=false
    Type=Application
    Categories=Network;InstantMessaging;Chat
    MimeType=x-scheme-handler/msteams;
  '';

  home.file.".gnupg/gpg.conf".text = ''
    use-agent
  '';

  # Ghostty dropdown terminal config
  home.file.".config/ghostty/dropdown.config".source = ../../dotfiles/ghostty/dropdown.config;

  home.sessionVariables = {
    EDITOR = "nvim";
    DIRENV_WARN_TIMEOUT = "20s";
    BROWSER = "firefox";
    PATH = "$HOME/.local/bin:$PATH";
  };

  programs.git = {
    enable = true;
    userName = "Nicky Tope";
    userEmail = "nicky.tope@gmail.com";
    aliases = {
      br = "!f() { git submodule foreach \"git checkout $1 || :\" && git checkout $1; }; f";
      compare = "!f() { echo showing commits in $1 that are not in $2; git --no-pager log --oneline $2..$1; }; f";
      compare-all = "!f() { git submodule foreach \"git compare $1 $2 || :\"; echo CORE; git compare $1 $2; }; f";
      npm = "git submodule foreach npm i && npm i";
    };
    extraConfig = {
      pull.rebase = false;
      core.editor = "nvim";
      merge.tool = "meld";
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        user = "git";
        identityFile = "~/.ssh/github";
      };
      "gitlab.com" = {
        user = "git";
        identityFile = "~/.ssh/gitlab";
      };
    };
  };

  programs.mpv.enable = true;
  
  # programs.firefox.enable = true; # Disabled - using system Firefox with passff-host

  services.remmina.enable = true;

  # Auto mount devices
  services.udiskie = {
    enable = true;
  };

  services.hyprpolkitagent.enable = true;

  services.gnome-keyring = {
    enable = true;
    components = ["secrets" "pkcs11" "ssh"];
  };

  # XDG user directories and configuration
  xdg = {
    enable = true;
    mime.enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      templates = null;
      desktop = null;
      publicShare = null;
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "$HOME/Pictures/Screenshots";
      };
    };
  };

  programs.home-manager.enable = true;
}
