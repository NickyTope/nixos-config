{pkgs, ...}: {
  xdg.configFile."ghostty/config".text = ''
    theme = nightfox
    font-size = 10
    font-family = Hurmit Nerd Font
    background-opacity = 0.85

    window-decoration = false
    gtk-titlebar = false
    gtk-tabs-location = bottom
    window-theme = ghostty
    gtk-wide-tabs = false
    adw-toolbar-style = flat

    keybind = global:super+y=toggle_quick_terminal
    keybind = super+alt+,=reload_config
  '';
}
