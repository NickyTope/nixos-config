{
  pkgs,
  config,
  ...
}: let
  inherit (config.lib.formats.rasi) mkLiteral;
in {
  home.packages = with pkgs; [
    rofi-emoji
    noto-fonts-emoji
  ];

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    plugins = [pkgs.rofi-emoji];

    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      terminal = "ghostty";
      drun-display-format = "{name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "󰍉";
      display-run = "󰍉";
      display-window = "";
      display-combi = "󰍉";
      sidebar-mode = false;
    };

    theme = ../../dotfiles/rofi/nightfox.rasi;
  };
}
