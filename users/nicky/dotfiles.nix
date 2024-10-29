{...}: {
  xdg.configFile.wezterm = {
    source = ../../dotfiles/wezterm;
    recursive = true;
  };

  xdg.configFile.bspwm = {
    source = ../../dotfiles/bspwm;
    recursive = true;
  };

  xdg.configFile.sxhkd = {
    source = ../../dotfiles/sxhkd;
    recursive = true;
  };

  xdg.configFile.polybar = {
    source = ../../dotfiles/polybar;
    recursive = true;
  };
}
