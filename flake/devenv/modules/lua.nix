{
  pkgs,
  lib,
  config,
  ...
}: {
  languages.lua.enable = true;

  packages = with pkgs; [
    lua-language-server
    stylua
    # Optional: luacheck for linting
    # luajitPackages.luacheck
  ];

  scripts = {
    fmt-lua.exec = ''
      echo "🎨 Formatting Lua files with stylua..."
      find . -name "*.lua" | xargs stylua
    '';

    check-lua.exec = ''
      echo "🔍 Checking Lua syntax..."
      find . -name "*.lua" -exec lua -l {} \; 2>/dev/null && echo "✅ Lua syntax OK"
    '';
  };

  scripts.lua-welcome.exec = ''
    echo "🌙 Lua development environment ready!"
    echo "Tools: lua-language-server (LSP), stylua (fmt)"
  '';

  enterShell = lib.mkAfter ''
    lua-welcome
  '';
}
