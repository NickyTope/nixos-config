{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  # import the sherlock homeManager Module
  imports = [
    inputs.sherlock.homeManagerModules.default
  ];

  # example configuration
  programs.sherlock = {
    enable = true;

    # for faster startup times
    runAsService = true;

    settings = {
      # config.json / config.toml
      # use nix syntax
      config = {
        appearance = {
          mod_key_ascii = ["󰘶" "󰪛" "󰯲" "󰯬" "󰽮" "󰯻" "" "󰯻"];
          width = 900;
          height = 593;
          gsk_renderer = "cairo";
          recolor_icons = false;
          icon_paths = [];
          icon_size = 22;
          search_icon = false;
          use_base_css = true;
          opacity = 1.0;
        };
        units = {
          currency = "aud";
        };
        search_bar_icon = {enable = false;};
      };

      # fallback.json
      # A list of launchers
      launchers = [
        {
          name = "Calculator";
          type = "calculation";
          args = {
            capabilities = [
              "calc.math"
              "calc.units"
            ];
          };
          priority = 1;
        }
        {
          name = "App Launcher";
          type = "app_launcher";
          args = {};
          priority = 2;
          home = "Home";
        }
        {
          name = "Emoji Picker";
          type = "emoji_picker";
          alias = "emoji";
          priority = 4;
          args = {
            default_skin_color = "Light";
          };
        }
        {
          name = "Power Menu";
          type = "power_menu";
          alias = "power";
          priority = 3;
          args = {
            actions = [
              {
                name = "Shutdown";
                icon = "system-shutdown";
                exec = "systemctl poweroff";
                method = "command";
              }
              {
                name = "Sleep";
                icon = "system-suspend";
                exec = "systemctl suspend";
                method = "command";
              }
              {
                name = "Lock";
                icon = "system-lock-screen";
                exec = "hyprlock";
                method = "command";
              }
              {
                name = "Reboot";
                icon = "system-reboot";
                exec = "systemctl reboot";
                method = "command";
              }
              {
                name = "Log Out";
                icon = "system-log-out";
                exec = "hyprctl dispatch exit";
                method = "command";
              }
            ];
          };
        }
      ];

      # sherlock_alias.json
      # use nix syntax
      aliases = {
        # vesktop = {name = "Discord";};
      };

      # main.css
      style =
        /*
        css
        */
        ''
          window {
              background: linear-gradient(135deg, rgba(35, 25, 50, 0.95) 0%, rgba(20, 15, 30, 0.95) 50%, rgba(10, 8, 15, 0.95) 100%);
              border-radius: 12px;
              border: 1px solid rgba(80, 60, 120, 0.4);
              box-shadow: 0 8px 32px rgba(0, 0, 0, 0.8);
          }

          .entry {
              background: transparent;
              border-radius: 8px;
              margin: 2px;
              padding: 8px 12px;
              transition: all 0.2s ease;
          }

          .entry:selected {
              background: rgba(10, 8, 15, 0.8);
              border: 1px solid rgba(80, 60, 120, 0.5);
          }

          .entry:hover {
              background: rgba(30, 20, 40, 0.6);
          }

          .search {
              background: rgba(20, 15, 30, 0.7);
              border: 1px solid rgba(80, 60, 120, 0.3);
              border-radius: 8px;
              padding: 8px 12px;
              margin: 8px;
              color: #e0e0e0;
          }

          .search:focus {
              border-color: rgba(120, 80, 160, 0.6);
              background: rgba(25, 18, 35, 0.8);
          }

          * {
              font-family: sans-serif;
              color: #e0e0e0;
          }
        '';

      # sherlockignore
      ignore = ''
        Avahi*
      '';
    };
  };
}
