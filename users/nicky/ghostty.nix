{...}: {
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "nightfox";
      font-size = 10;
      font-family = "FiraCode Nerd Font";
      font-family-bold = "FiraCode Nerd Font Med";
      font-family-italic = "Victor Mono Nerd Font";
      background-opacity = 0.85;
      adjust-cell-height = "5%";

      window-decoration = false;
      gtk-titlebar = false;
      gtk-tabs-location = "bottom";
      window-theme = "ghostty";
      gtk-wide-tabs = false;
      adw-toolbar-style = "flat";
    };
  };
}
