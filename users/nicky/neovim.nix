{ pkgs, config, inputs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    defaultEditor = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
  };

  xdg.configFile.nvim = {
    source = config.lib.file.mkOutOfStoreSymlink /home/nicky/code/nixos-config/dotfiles/nvim;
    recursive = true;
  };
}

