{pkgs, ...}: {
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
        front_end = "WebGpu",
        webgpu_power_preference = "HighPerformance",
        color_scheme = "nightfox",
        audible_bell = "Disabled",
        check_for_updates = false,
        enable_tab_bar = true,
        tab_bar_at_bottom = true,
        use_fancy_tab_bar = false,
        hide_tab_bar_if_only_one_tab = true,
        window_background_opacity = 0.85,
        window_padding = {
          left = 2,
          right = 2,
          top = 2,
          bottom = 0,
        },
        keys = {
          { key = "v", mods = "ALT", action = wezterm.action.PasteFrom("Clipboard") },
          { key = "t", mods = "CTRL|SHIFT", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
          { key = "v", mods = "CTRL|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
          { key = "h", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Left") },
          { key = "l", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Right") },
          { key = "k", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Up") },
          { key = "j", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Down") },
        },
        colors = {
          tab_bar = {
            inactive_tab_edge = "#dddddd",
          },
        },
        font = wezterm.font({
          family = "Hurmit Nerd Font",
        }),
        font_size = 10,
        cell_width = 0.9,
      }
    '';
  };
}
