{pkgs, ...}: {
  home.packages = [
    # pkgs.nodejs => 20.18.1
    # unstable.nodejs_22 => 22.11.0
    # pkgs.nodejs_22 => 22.12.0
    pkgs.nodejs_22
  ];

  programs.bun = {
    enable = true;
  };

  home.file.".npmrc".text = ''
    prefix=/home/nicky/.npm-global
  '';
}
