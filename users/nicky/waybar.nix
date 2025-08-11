{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true; # Enable waybar systemd service
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 24;
        spacing = 4;
        output = []; # Let waybar auto-detect outputs

        modules-left = ["hyprland/workspaces" "hyprland/window"];
        modules-center = ["clock"];
        # modules-right will be defined by host-specific configuration

        # Workspace configuration
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = false;
          warp-on-scroll = false;
          format = "{name}: {icon}";
          format-icons = {
            "1" = "󰆍";
            "2" = "󰒋";
            "3" = "󰖟";
            "4" = "󰒓";
            "5" = "󰎄";
            urgent = "󰀧";
            focused = "󰮯";
            default = "󰊠";
          };
        };

        # Window title
        "hyprland/window" = {
          format = "{}";
          max-length = 50;
        };

        # System tray
        tray = {
          icon-size = 15;
          spacing = 10;
        };

        # Clock
        clock = {
          timezone = "Australia/Melbourne";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };

        # CPU
        cpu = {
          format = "{usage}% 󰘚";
          tooltip = false;
        };

        # Memory
        memory = {
          format = "{}% 󰍛";
        };

        # Temperature
        temperature = {
          thermal-zone = 2;
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 80;
          format-critical = "{temperatureC}°C 󰸁";
          format = "{temperatureC}°C 󰔏";
          format-icons = ["󰔏" "󰔐" "󰸁"];
        };

        # Battery (will be enabled by host-specific config)
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% 󰂄";
          format-plugged = "{capacity}% 󰚥";
          format-alt = "{time} {icon}";
          format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        };

        # Network
        network = {
          format-wifi = "{essid} ({signalStrength}%) 󰤨";
          format-ethernet = "{ipaddr}/{cidr} 󰈀";
          tooltip-format = "{ifname} via {gwaddr} 󰩟";
          format-linked = "{ifname} (No IP) 󰈂";
          format-disconnected = "Disconnected 󰤭";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };

        # PulseAudio
        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = "󰸈 {icon} {format_source}";
          format-muted = "󰸈 {format_source}";
          format-source = "{volume}% 󰍬";
          format-source-muted = "󰍭";
          format-icons = {
            headphone = "󰋋";
            hands-free = "󱡒";
            headset = "󰋎";
            phone = "󰏲";
            portable = "󰦧";
            car = "󰄋";
            default = ["󰕿" "󰖀" "󰕾"];
          };
          on-click = "pavucontrol";
        };
      };
    };

    # Use Skxxtz-inspired styling
    style = builtins.readFile ../../dotfiles/hyprland/waybar-style-skxxtz.css;
  };
}
