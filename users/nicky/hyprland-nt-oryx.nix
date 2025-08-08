{...}: {
  # nt-oryx (System76 laptop) specific Hyprland configuration
  wayland.windowManager.hyprland.settings = {
    # Monitor setup for nt-oryx (laptop + external monitor support)
    monitor = [
      "eDP-1,preferred,0x0,1" # Laptop screen
      "DP-1,preferred,auto,1" # External monitor via DisplayPort
      "HDMI-A-1,preferred,auto,1" # External monitor via HDMI
      ",preferred,auto,1" # Fallback for other monitors
    ];

    # Host-specific startup commands
    exec-once = [
      # System76 laptop specific settings
      "sudo system76-power profile battery"
      "light -S 60" # Set screen brightness to 60%
      "sudo sys76-kb set -c purple -b 90" # Set keyboard backlight
    ];

    # nt-oryx specific workspace layout
    # Single monitor: all workspaces on main
    # Dual monitor: term on first monitor, rest on second
    workspace = [
      "1, name:term, monitor:eDP-1"
      "2, name:api, monitor:DP-1"
      "3, name:webfront, monitor:DP-1"
      "4, name:config, monitor:DP-1"
      "5, name:five, monitor:DP-1"
      "6, name:web, monitor:DP-1"
      "7, name:chat, monitor:DP-1"
      "8, name:win, monitor:DP-1"
      "9, name:nine, monitor:DP-1"
      "10, name:ten, monitor:DP-1"
      "special:scratchpad, on-created-empty:ghostty --class=scratchterm"
    ];
  };

  # nt-oryx-specific waybar configuration  
  programs.waybar.settings.mainBar = {
    output = [ "eDP-1" ]; # Laptop screen
    modules-right = [ "memory" "cpu" "temperature" "battery" "pulseaudio" "network" "tray" ]; # Include battery
  };
}
