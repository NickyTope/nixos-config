{unstable, ...}: {
  home.packages = [
    unstable.nodejs_22
  ];

  programs.bun = {
    enable = true;
  };

  home.file.".npmrc".text = ''
    prefix=/home/nicky/.npm-global
  '';
}
