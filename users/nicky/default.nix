{ config, pkgs, lib, ... }:

{
  imports = [
    ./cloud.nix
    ./dotfiles.nix
    ./neovim.nix
    ./nodejs.nix
    ./openai.nix
    ./secrets.nix
    ./wezterm.nix
    ./zsh.nix
  ];

  home.username = "nicky";
  home.homeDirectory = "/home/nicky";
  home.stateVersion = "24.11";
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = ["Hermit" "JetBrainsMono" "Noto" ]; })
    fira-code
    roboto-mono
    icomoon-feather
    material-icons
    bat
    ripgrep
    bun
    lazygit
    stylua
    lua-language-server
  ];

  home.file.".gnupg/gpg.conf".text = ''
    use-agent
  '';

  home.sessionVariables = {
    EDITOR = "nvim";
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
    };
  };

  home.pointerCursor = {
    package = pkgs.fuchsia-cursor;
    name = "Fuchsia";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  programs.mpv.enable = true;

  gtk = {
    enable = true;
    iconTheme = {
      name = "Dracula";
      package = pkgs.dracula-icon-theme;
    };
    theme = {
      name = "Nightfox-Dark";
      package = pkgs.nightfox-gtk-theme;
    };
  };

  qt = {
    enable = true;
    platformTheme = {
      name = "gtk3";
    };
    style = {
      name = "Fusion";
      package = pkgs.dracula-qt5-theme;
    };
  };

  home.file.".icons/default/index.theme".text = ''
    [Icon Theme]
    Inherits=Fuchsia
    '';

  # Screen lock
  services = {
    screen-locker = {
      enable = true;
      inactiveInterval = 10;
      lockCmd = "${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 10 15";
    };

    # Auto mount devices
    udiskie = {
      enable = true;
    };

    gnome-keyring = {
      enable = true;
      components = ["secrets" "pkcs11" "ssh"];
    };

    clipmenu = {
      enable = true;
      launcher = "rofi";
    };
  };

  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

}
