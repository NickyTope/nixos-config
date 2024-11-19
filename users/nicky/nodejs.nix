{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    nodejs_22
  ];

  programs.bun = {
    enable = true;
  };

  home.file.".npmrc".text = ''
    prefix=/home/nicky/.npm-global
  '';
}
