{...}: {
  # mininix (desktop) specific Hyprland configuration
  wayland.windowManager.hyprland.settings = {
    # Monitor setup for mininix (desktop with dual monitors)
    monitor = [
      "DisplayPort-0,preferred,0x0,1"        # First monitor
      "DisplayPort-1,preferred,2560x0,1"     # Second monitor to the right
      "DisplayPort-3,preferred,0x0,1"        # Alternative DP3
      "DisplayPort-4,preferred,2560x0,1"     # Alternative DP4
      ",preferred,auto,1"                     # Fallback for other monitors
    ];

    # mininix specific workspace layout
    # Single monitor: all workspaces on main
    # Dual monitor: split workspaces between monitors
    workspace = [
      "1, name:term, monitor:DisplayPort-0"
      "2, name:api, monitor:DisplayPort-0"
      "3, name:webfront, monitor:DisplayPort-0"
      "4, name:config, monitor:DisplayPort-0" 
      "5, name:five, monitor:DisplayPort-0"
      "6, name:web, monitor:DisplayPort-1"
      "7, name:chat, monitor:DisplayPort-1"
      "8, name:win, monitor:DisplayPort-1"
      "9, name:nine, monitor:DisplayPort-1"
      "10, name:ten, monitor:DisplayPort-1"
      "special:scratchpad, on-created-empty:ghostty --class=scratchterm"
    ];
  };

  # mininix-specific waybar configuration
  programs.waybar.settings.mainBar = {
    output = [ "DP-2" ]; # Desktop monitor
    modules-right = [ "memory" "cpu" "temperature" "pulseaudio" "network" "tray" ]; # No battery
  };
}