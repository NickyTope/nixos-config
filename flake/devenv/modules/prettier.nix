{
  pkgs,
  lib,
  config,
  ...
}: {
  packages = with pkgs; [
    nodePackages.prettier
    nodePackages.eslint
    prettierd
  ];

  env = {
    JSTS_FORMATTER = "prettierd";
    CSS_FORMATTER = "prettierd";
  };

  scripts = {
    prettier-welcome.exec = ''
      echo "💅 Prettier + ESLint ready!"
      echo "Prettier version: $(prettier --version)"
      echo "ESLint version: $(eslint --version)"
    '';

    lint.exec = ''
      echo "🔍 Running ESLint..."
      eslint . --ext .ts,.tsx,.js,.jsx
    '';

    lint-fix.exec = ''
      echo "🔧 Running ESLint with --fix..."
      eslint . --ext .ts,.tsx,.js,.jsx --fix
    '';

    format.exec = ''
      echo "🎨 Running Prettier..."
      prettier --write .
    '';
  };

  enterShell = lib.mkAfter ''
    prettier-welcome
  '';
}
