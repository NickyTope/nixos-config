{
  config,
  lib,
  pkgs,
  ...
}: {
  # Enable Hyprland with Home Manager
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;

    settings = {
      # Set the modifier key (Super/Windows key)
      "$mod" = "SUPER";

      # Monitor configuration will be overridden by host-specific modules

      # Input configuration
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        natural_scroll = true; # Reverse scroll direction
        touchpad = {
          natural_scroll = true; # Also reverse touchpad scroll
        };
      };

      # Environment variables for proper X11 app integration and keyring
      env = [
        "XCURSOR_THEME,layan-cursors"
        "XCURSOR_SIZE,16"
        "GNOME_KEYRING_CONTROL,/run/user/1000/keyring"
        "SSH_ASKPASS,/run/current-system/sw/bin/seahorse-ssh-askpass"
      ];

      # General settings
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      # Decoration settings
      decoration = {
        rounding = 5;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
      };

      # Animation settings - faster animations
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 4, myBezier"
          "windowsOut, 1, 4, default, popin 80%"
          "border, 1, 6, default"
          "fade, 1, 4, default"
          "workspaces, 1, 3, default"
        ];
      };

      # Dwindle layout settings
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # Key bindings - mapped from your sxhkd configuration
      bind = [
        # Basic window management
        "$mod, Return, exec, ghostty"
        "$mod, Space, exec, wofi --show drun"
        "$mod, d, exec, wofi --show drun"
        "$mod, e, exec, wofi --show drun" # Note: wofi doesn't have emoji support like rofi
        "$mod, w, killactive"
        "$mod ALT, w, exec, kill -9 $(hyprctl activewindow -j | jq -r '.pid')"

        # Window states
        "$mod, t, togglefloating"
        "$mod, f, fullscreen, 0"
        "$mod SHIFT, f, fullscreen, 1" # fake fullscreen
        "$mod SHIFT, t, pin" # equivalent to pseudo_tiled

        # Focus management
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        # Move windows
        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, l, movewindow, r"
        "$mod SHIFT, k, movewindow, u"
        "$mod SHIFT, j, movewindow, d"

        # Workspace navigation
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move to workspace
        "$mod SHIFT, 1, movetoworkspacesilent, 1"
        "$mod SHIFT, 2, movetoworkspacesilent, 2"
        "$mod SHIFT, 3, movetoworkspacesilent, 3"
        "$mod SHIFT, 4, movetoworkspacesilent, 4"
        "$mod SHIFT, 5, movetoworkspacesilent, 5"
        "$mod SHIFT, 6, movetoworkspacesilent, 6"
        "$mod SHIFT, 7, movetoworkspacesilent, 7"
        "$mod SHIFT, 8, movetoworkspacesilent, 8"
        "$mod SHIFT, 9, movetoworkspacesilent, 9"
        "$mod SHIFT, 0, movetoworkspacesilent, 10"

        # Window cycling
        "$mod, c, cyclenext"
        "$mod SHIFT, c, cyclenext, prev"
        "$mod, Tab, workspace, previous"
        "$mod, grave, focusurgentorlast"

        # Desktop/workspace cycling
        "$mod, v, workspace, +1"
        "$mod SHIFT, v, workspace, -1"

        # Window manipulation
        "$mod, g, layoutmsg, swapwithmaster"
        "$mod, m, layoutmsg, orientationnext"
        "$mod, apostrophe, layoutmsg, resetarea"
        "$mod, y, layoutmsg, swapwithmaster"

        # Ultrawide 3-window layout helpers
        "$mod CTRL, equal, exec, hyprctl dispatch splitratio 0" # Reset split ratios to equal
        "$mod CTRL, 1, exec, hyprctl dispatch splitratio -0.1" # Make focused window smaller
        "$mod CTRL, 2, exec, hyprctl dispatch splitratio +0.1" # Make focused window larger
        "$mod CTRL, 3, exec, hyprctl dispatch resizewindowpixel exact 1706 1440" # Resize to 1/3 width

        # Special functions
        "$mod, p, pin"
        "$mod, u, exec, ghostty --class=ghostty-dropdown"
        "$mod SHIFT, u, movetoworkspace, special:scratchpad"

        # System controls
        "$mod ALT, r, exec, hyprctl reload"
        "$mod ALT, q, exec, ~/.config/bspwm/logout.sh" # reuse existing logout script
        "$mod, Escape, exec, pkill -USR1 -x sxhkd" # keep for compatibility

        # Applications (from your launcher bindings)
        "$mod o, f, exec, firefox-developer-edition"
        "$mod o, s, exec, slack"
        "$mod o, z, exec, zoom"
        "$mod o, t, exec, teams"

        # Utilities
        "$mod SHIFT, w, exec, ~/code/nixos-config/dotfiles/hyprland/setwall.sh"
        "$mod, n, exec, notify-send 'Network menu not implemented yet'"
        "$mod CTRL, b, exec, ~/.config/polybar/scripts/btmenu.sh"
        "$mod CTRL, a, exec, ~/.config/polybar/scripts/pamenu.sh"
        "$mod CTRL ALT, t, exec, rofi-pass" # Keep rofi-pass as it's a specific tool
        "$mod SHIFT, m, exec, ~/.config/bspwm/monitor_detect.sh"
        "CTRL ALT, l, exec, hyprlock"
        "$mod ALT, q, exec, hyprctl dispatch exit"
        "$mod ALT, c, exec, pick-colour-picker"
        "$mod ALT, s, exec, /home/nicky/apps/ticker.sh/notify-shares"
        "$mod, r, exec, eruler"
        "CTRL ALT, v, exec, clipcat-menu"

        # Screenshot bindings
        "$mod ALT, p, exec, grim ~/Pictures/screens/Screenshot_$(date +%s).png"
        "$mod SHIFT, p, exec, grim -g \"$(slurp)\" - | wl-copy"
        "$mod CTRL, p, exec, grim -g \"$(slurp)\" ~/Pictures/screens/Screenshot_$(date +%s).png"
      ];

      # Resize mode bindings
      binde = [
        # Resize windows
        "$mod ALT, h, resizeactive, -20 0"
        "$mod ALT, l, resizeactive, 20 0"
        "$mod ALT, k, resizeactive, 0 -20"
        "$mod ALT, j, resizeactive, 0 20"

        # Contract windows (opposite direction)
        "$mod ALT SHIFT, h, resizeactive, 20 0"
        "$mod ALT SHIFT, l, resizeactive, -20 0"
        "$mod ALT SHIFT, k, resizeactive, 0 20"
        "$mod ALT SHIFT, j, resizeactive, 0 -20"

        # Move floating windows with arrow keys
        "$mod, left, moveactive, -20 0"
        "$mod, right, moveactive, 20 0"
        "$mod, up, moveactive, 0 -20"
        "$mod, down, moveactive, 0 20"
      ];

      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Media key bindings
      bindl = [
        ", XF86AudioMute, exec, ponymix toggle"
        ", XF86AudioLowerVolume, exec, /home/nicky/code/nixos-config/dotfiles/bspwm/volume.sh -2%"
        ", XF86AudioRaiseVolume, exec, /home/nicky/code/nixos-config/dotfiles/bspwm/volume.sh +2%"
        ", XF86MonBrightnessUp, exec, brightnessctl set +10%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
      ];

      # Base workspace configuration (will be extended by host-specific modules)
      workspace = [
        "special:scratchpad, on-created-empty:ghostty --class=scratchterm"
      ];

      # Startup applications and scripts
      exec-once = [
        # Wallpaper and waybar
        "/home/nicky/code/nixos-config/dotfiles/hyprland/launch-waybar.sh"
        "/home/nicky/code/nixos-config/dotfiles/hyprland/setwall.sh"

        "light -S 60" # Set screen brightness to 60%
        "sudo sys76-kb set -c purple -b 90" # Set keyboard backlight

        # Volume control
        "killall volumeicon; volumeicon"

        # GNOME keyring for password management
        "gnome-keyring-daemon --start --components=secrets"

        # Time sync
        "timedatectl timesync-status"

        # Welcome message
        "/home/nicky/code/nixos-config/dotfiles/bspwm/welcome.sh"

        # Launch Firefox on startup
        "firefox-developer-edition"
      ];

      # Host-specific startup will be added via separate modules

      # Window rules (from bspwmrc)
      windowrulev2 = [
        # General floating rules
        "float,class:^(wofi)$"
        "float,class:^(rofi)$" # Keep for rofi-pass
        
        # Dropdown terminal
        "float,class:^(ghostty-dropdown)$"
        "size 1200 700,class:^(ghostty-dropdown)$"
        "move 360 50,class:^(ghostty-dropdown)$"
        "float,title:^(ghostty-dropdown)$"
        "float,class:^(thunar)$"
        "float,class:^(Thunar)$"
        "float,class:^(nemo)$"
        "float,class:^(Nemo)$"
        "float,class:^(org.gnome.Calculator)$"
        "float,class:^(org.gnome.Nautilus)$"

        # Application specific rules
        "float,class:^(gitk)$"
        "float,class:^(.*):dialog$"
        "float,class:^(simplescreenrecorder)$"
        "float,class:^(galculator)$"
        "float,class:^(xfce4-appfinder)$"
        "float,class:^(.blueman-manager-wrapped)$"
        "size 400 800,class:^(.blueman-manager-wrapped)$"
        "move 1380 40,class:^(.blueman-manager-wrapped)$"
        "float,class:^(.pick-colour-picker-wrapped)$"
        "float,class:^(AFFiNE)$"
        "float,class:^(bitwarden)$"
        "float,class:^(pavucontrol)$"
        "size 680 500,class:^(bitwarden)$"
        "center 1,class:^(bitwarden)$"

        # Scratchpad terminal - smaller floating window in center
        "float,title:^(scratchterm)$"
        "size 1200 600,title:^(scratchterm)$"
        "center 1,title:^(scratchterm)$"
        "workspace special:scratchpad,title:^(scratchterm)$"

        # Firefox workspace restoration
        "suppressevent maximize, class:^(firefox)$"
        "suppressevent fullscreen, class:^(firefox)$"
      ];
    };
  };

  # Additional Wayland packages needed
  home.packages = with pkgs; [
    # Screenshot and clipboard tools for Wayland
    grim
    slurp
    wl-clipboard

    # Wallpaper tool for Wayland
    hyprpaper

    # Brightness control
    brightnessctl

    # Screen locker for Hyprland
    hyprlock

    # Status bar for Wayland
    waybar

    # Notification daemon
    dunst

    # GNOME keyring integration
    libsecret
    seahorse

    # App launcher (alternative to rofi)
    wofi
  ];

  # Configure hyprlock
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 5;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = "Password...";
          shadow_passes = 2;
        }
      ];
    };
  };

  # Configure mako for notifications
  services.mako = {
    enable = true;
    settings = {
      background-color = "#2e3440";
      border-color = "#88c0d0";
      border-radius = 5;
      border-size = 2;
      text-color = "#eceff4";
      default-timeout = 5000;
    };
  };
}
