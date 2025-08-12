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

    # Install hy3 plugin for better tiling
    plugins = [
      pkgs.hyprlandPlugins.hy3
    ];

    settings = {
      # Set the modifier key (Super/Windows key)
      "$mod" = "SUPER";

      # Enable hyprcursor for improved Wayland cursor theming
      cursor = {
        enable_hyprcursor = true;
      };

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

      # Environment variables for cursor theming, keyring, and X11 app integration
      env = [
        # Hyprcursor settings (primary for Wayland/server-side cursor apps) - TESTING WITH LARGE SIZE
        "HYPRCURSOR_THEME,rose-pine-hyprcursor"
        "HYPRCURSOR_SIZE,24"

        # XCursor fallback settings (for GTK and other legacy cursor apps)
        "XCURSOR_THEME,BreezeX-RosePine-Linux"
        "XCURSOR_SIZE,24"

        # System integration
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
          enabled = false;
        };
        inactive_opacity = 0.8;
        active_opacity = 1.0;
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

      # Dwindle layout settings (defaults)
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # Key bindings - mapped from your sxhkd configuration
      bind = [
        # Basic window management
        "$mod, Return, exec, ghostty"
        "$mod, Space, exec, rofi -show run"
        "$mod, d, exec, rofi -show drun"
        "$mod, e, exec, rofi -modi emoji -show emoji"
        "$mod, c, exec, rofi -modi calc -show calc -no-sort -no-show-match"
        "$mod, tab, exec, rofi -show window"
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

        # Clipboard management
        "$mod, v, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"

        # Layout helpers
        "$mod, equal, exec, hyprctl dispatch splitratio exact 1" # Reset current split to equal
        "$mod, minus, exec, hyprctl dispatch splitratio -0.1" # Make focused window smaller
        "$mod, plus, exec, hyprctl dispatch splitratio +0.1" # Make focused window larger
        "$mod SHIFT, r, exec, hyprctl dispatch resizeactive exact 67% 67%" # Resize to 2/3 current size
        "$mod, s, layoutmsg, togglesplit" # Toggle split direction
        "$mod, x, layoutmsg, swapsplit" # Swap split
        "$mod, m, layoutmsg, movetoroot" # Move window to root

        # Special functions
        "$mod, u, exec, /home/nicky/code/nixos-config/dotfiles/hyprland/dropdown-toggle.sh"
        "$mod, i, exec, /home/nicky/code/nixos-config/dotfiles/hyprland/affine-dropdown-toggle.sh"
        "$mod, o, exec, /home/nicky/code/nixos-config/dotfiles/hyprland/thunar-dropdown-toggle.sh"
        "$mod, slash, exec, /home/nicky/code/nixos-config/dotfiles/hyprland/show-keybinds.sh"

        # System controls
        "$mod ALT, r, exec, hyprctl reload"
        "$mod ALT, q, exec, /home/nicky/code/nixos-config/dotfiles/hyprland/rofi-power-menu.sh"

        # Utilities
        "$mod SHIFT, w, exec, ~/code/nixos-config/dotfiles/hyprland/setwall.sh"
        "$mod, n, exec, notify-send 'Network menu not implemented yet'"
        "CTRL ALT, l, exec, hyprlock"
        "$mod ALT, c, exec, hyprpicker -a"
        "$mod ALT, s, exec, /home/nicky/apps/ticker.sh/notify-shares"

        # Screenshot bindings
        "$mod ALT, p, exec, grim ~/Pictures/screens/Screenshot_$(date +%s).png"
        "$mod SHIFT, p, exec, grim -g \"$(slurp)\" - | wl-copy"
        "$mod CTRL, p, exec, grim -g \"$(slurp)\" ~/Pictures/screens/Screenshot_$(date +%s).png"

        # Toggle screen recording
        "$mod, r, exec, /home/nicky/code/nixos-config/dotfiles/hyprland/toggle-recording.sh"
      ];

      # Resize mode bindings
      binde = [
        # Resize windows with Super + Alt + hjkl (keeping familiar position)
        "$mod ALT, h, resizeactive, -20 0"
        "$mod ALT, l, resizeactive, 20 0"
        "$mod ALT, k, resizeactive, 0 -20"
        "$mod ALT, j, resizeactive, 0 20"

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

      # Startup applications and scripts
      exec-once = [
        # Always start on workspace 1
        "hyprctl dispatch workspace 1"

        # Wallpaper - waybar now managed by Home Manager
        "/home/nicky/code/nixos-config/dotfiles/hyprland/setwall.sh"

        "sudo sys76-kb set -c purple -b 90" # Set keyboard backlight

        # Volume control
        "killall volumeicon; volumeicon"

        # GNOME keyring for password management
        "gnome-keyring-daemon --start --components=secrets"

        # Time sync
        "timedatectl timesync-status"

        # Welcome message
        "/home/nicky/code/nixos-config/dotfiles/bspwm/welcome.sh"

        "nm-applet"
      ];

      # Host-specific startup will be added via separate modules

      # Window rules (from bspwmrc)
      windowrulev2 = [
        # General floating rules
        "float,class:^(rofi)$"

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
        "float,class:^(bitwarden)$"
        "float,class:^(pavucontrol)$"
        "size 680 500,class:^(bitwarden)$"
        "center 1,class:^(bitwarden)$"

        # Dropdown window rules - center on active monitor
        "float,title:^(dropdown-ghostty)$"
        "size 1200 700,title:^(dropdown-ghostty)$"
        "center,title:^(dropdown-ghostty)$"

        "float,class:^(AFFiNE)$"
        "size 1200 700,title:^(AFFINE)$"
        "center,title:^(AFFINE)$"

        "float,class:^(thunar)$"
        "size 1200 700,title:^(thunar)$"
        "center,title:^(thunar)$"

        # Firefox workspace restoration
        "suppressevent maximize, class:^(firefox)$"
        "suppressevent fullscreen, class:^(firefox)$"

        # Zoom window rules - prevent focus stealing
        "nofocus, class:^(zoom)$, title:^(Chat)$"
        "nofocus, class:^(zoom)$, title:^(Zoom Chat)$"
        "nofocus, class:^(zoom)$, title:^(zoom)$"
        "nofocus, class:^(zoom)$, title:^(Zoom)$"
        "nofocus, class:^(zoom)$, title:.*notification.*"
        "nofocus, class:^(zoom)$, title:.*message.*"
        "nofocus, class:^(zoom)$, title:.*popup.*"
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

    # Idle management for Hyprland
    hypridle

    # Color picker for Hyprland
    hyprpicker

    # Notification daemon
    dunst

    # GNOME keyring integration
    libsecret
    seahorse
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

  # Configure hypridle for power management
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        # Dim screen after 5 minutes
        {
          timeout = 300;
          on-timeout = "brightnessctl -s set 10%";
          on-resume = "brightnessctl -r";
        }
        # Turn off screen after 10 minutes
        {
          timeout = 600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        # Lock screen after 15 minutes
        {
          timeout = 900;
          on-timeout = "loginctl lock-session";
        }
      ];
    };
  };
}
