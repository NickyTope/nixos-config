{
  pkgs,
  lib,
  ...
}: {
  home.packages = [
    # pkgs.nodejs => 20.18.1
    # unstable.nodejs_22 => 22.11.0
    # pkgs.nodejs_22 => 22.12.0
    pkgs.nodejs_22
    # pkgs.typescript # this doesn't update regularly enough
  ];

  programs.bun = {
    enable = true;
  };

  home.activation.initnpmrc = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -f /home/nicky/.npmrc ]; then
      echo "prefix=/home/nicky/.npm-global" > ~/.npmrc
    fi
  '';
}
