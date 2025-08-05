{
  pkgs,
  lib,
  config,
  ...
}: {
  packages = with pkgs; [
    nodePackages.prisma
    openssl
  ];

  env = {
    PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
    PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
    PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
    PRISMA_FMT_BINARY = "${pkgs.prisma-engines}/bin/prisma-fmt";
  };

  scripts.prisma-welcome.exec = ''
    echo "🗄️  Prisma environment ready!"
    # echo "Prisma version: $(prisma --version)"
  '';

  enterShell = lib.mkAfter ''
    prisma-welcome
  '';
}
