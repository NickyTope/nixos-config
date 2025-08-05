{
  pkgs,
  lib,
  config,
  ...
}: {
  languages.typescript = {
    enable = true;
  };

  languages.javascript = {
    enable = true;
    corepack.enable = true;
  };

  packages = with pkgs; [
    nodejs_22
    nodePackages.npm
    nodePackages.typescript
    nodePackages.ts-node
    bun
  ];

  env = {
    TS_NODE_COMPILER_OPTIONS = ''{"module":"commonjs","target":"es2020"}'';
    # Set npm prefix to avoid global package conflicts
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  };

  scripts.setup-npm.exec = ''
    # Create .npmrc if it doesn't exist (similar to your home-manager activation)
    if [ ! -f "$HOME/.npmrc" ]; then
      echo "prefix=$HOME/.npm-global" > "$HOME/.npmrc"
      echo "Created ~/.npmrc with global prefix"
    fi

    # Ensure the global npm directory exists
    mkdir -p "$HOME/.npm-global"
  '';

  scripts.ts-welcome.exec = ''
    echo " ready!  $(node --version)  $(npm --version)  $(tsc --version | cut -d' ' -f2)  $(bun --version)"
  '';

  enterShell = lib.mkAfter ''
    ts-welcome
    setup-npm
  '';
}
