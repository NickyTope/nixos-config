{pkgs, ...}: {
  home.packages = with pkgs; [
    rofi-pass
    rofi-systemd
  ];

  programs.rofi = {
    enable = true;
    plugins = with pkgs; [
      rofi-emoji
      rofi-calc
    ];
  };

  xdg.configFile.rofi = {
    source = ../../dotfiles/rofi;
    recursive = true;
  };
}
