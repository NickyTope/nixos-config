{
  pkgs,
  lib,
  config,
  ...
}: {
  packages = with pkgs; [
    nodePackages.stylelint
  ];

  scripts.stylelint-welcome.exec = ''
    echo "💄 Stylelint ready!"
    echo "Stylelint version: $(stylelint --version)"
  '';

  scripts.lint-css.exec = ''
    echo "🔍 Running Stylelint..."
    stylelint "**/*.{css,scss,sass}"
  '';

  scripts.lint-css-fix.exec = ''
    echo "🔧 Running Stylelint with --fix..."
    stylelint "**/*.{css,scss,sass}" --fix
  '';

  enterShell = lib.mkAfter ''
    stylelint-welcome
  '';
}
