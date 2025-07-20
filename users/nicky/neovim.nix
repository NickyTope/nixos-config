{
  pkgs,
  config,
  inputs,
  unstable,
  ...
}: {
  # TODO: add other lsp servers here
  home.packages = with pkgs; [
    lazygit
    gopls
    python3Packages.python-lsp-server
    lemminx
    nodePackages.eslint
    eslint_d
    unstable.biome
    nodePackages.nodemon
    nodePackages.prettier
    prettierd
    stylelint
    stylelint-lsp
    vim-language-server
    vscode-langservers-extracted
    emmet-ls
    yaml-language-server
    dockerfile-language-server-nodejs
  ];

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
