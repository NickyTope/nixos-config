{
  pkgs,
  lib,
  config,
  ...
}: {
  packages = [
    pkgs.terramate
    pkgs.terragrunt
    pkgs.pre-commit
  ];

  languages.opentofu.enable = true;

  git-hooks = {
    package = pkgs.pre-commit;
  };

  scripts.ts-welcome.exec = ''
    echo "tg ready!"
  '';

  enterShell = lib.mkAfter ''
    tg-welcome
  '';
}
