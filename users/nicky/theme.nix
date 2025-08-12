{pkgs, ...}: {
  home.pointerCursor = {
    package = pkgs.rose-pine-hyprcursor;
    name = "BreezeX-RosePine-Linux";
    size = 16;
    gtk.enable = true;
    x11.enable = true;
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

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
    Inherits=BreezeX-RosePine-Linux
  '';
}
