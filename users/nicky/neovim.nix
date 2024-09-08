{ pkgs, config, ... }:

{
  home.packages = [
    pkgs.neovim
  ];

  xdg.configFile.nvim = {
    source = config.lib.file.mkOutOfStoreSymlink /home/nicky/code/nixos-config/dotfiles/nvim;
    recursive = true;
  };
}

