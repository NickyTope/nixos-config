{
  pkgs,
  lib,
  config,
  ...
}: {
  # Set devenv root to current directory to fix directory detection
  devenv.root = lib.mkDefault (builtins.toString ./.);

  # Common environment setup
  packages = with pkgs; [
    # Common tools every project might need
    git
    curl
    jq
  ];

  scripts.setup-common.exec = ''
    echo "Setting up common development environment..."
  '';

  enterShell = ''
    setup-common
  '';
}
