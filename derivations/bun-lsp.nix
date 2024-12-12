{
  stdenv,
  bun,
}:
stdenv.mkDerivation {
  pname = "bun-lsp";
  version = "0.1";
  src = ./.;
  buildInputs = [bun];
  buildPhase = ''
    bun add --global @babel/cli @babel/core @babel/node concurrently dockerfile-language-server-nodejs eslint eslint_d neovim nodemon prettier stylelint stylelint-lsp tslib typescript vim-language-server vscode-css-languageserver-bin vscode-json-languageserver cssmodules-language-server @tailwindcss/language-server vscode-langservers-extracted emmet-ls @vtsls/language-server yaml-language-server
  '';
  installPhase = ''
    mkdir -p $out/bin
    echo "hello world" > $out/bin/hello
  '';
}
