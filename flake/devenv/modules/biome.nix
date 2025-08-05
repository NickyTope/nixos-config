{
  pkgs,
  lib,
  config,
  ...
}: {
  packages = with pkgs; [
    biome
  ];

  env = {
    JSTS_FORMATTER = "biome-check";
    CSS_FORMATTER = "biome-check";
  };

  scripts.setup-biome.exec = ''
    # Only try to create symlink if we're in a writable directory
    if [ -w "." ] && [ -d "./node_modules/@biomejs/biome/bin" ]; then
      rm -f ./node_modules/@biomejs/biome/bin/biome
      ln -s $(which biome) ./node_modules/@biomejs/biome/bin/biome
      echo "Biome symlink created"
    fi
  '';

  scripts.biome-welcome.exec = ''
    echo "🏃 Biome formatter/linter ready!"
    echo "Biome version: $(biome --version)"
  '';

  enterShell = lib.mkAfter ''
    biome-welcome
    setup-biome
  '';
}
