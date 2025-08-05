{
  pkgs,
  lib,
  config,
  ...
}: {
  scripts.combined-fmt.exec = ''
    fmt-nix
    fmt-lua
  '';

  scripts.combined-welcome.exec = ''
    echo "🏗️  NixOS + Neovim Development Environment Ready!"
    echo "Use 'combined-fmt' to format all files"
  '';

  enterShell = lib.mkAfter ''
    combined-welcome
  '';
}
