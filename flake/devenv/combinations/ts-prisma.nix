{
  pkgs,
  lib,
  config,
  ...
}: {
  scripts.combined-welcome.exec = ''
    echo "🚀 Full-stack TypeScript + Prisma environment ready!"
    echo "Perfect for: Next.js, Express + Prisma, tRPC, etc."
  '';

  scripts.init-prisma-ts.exec = ''
    if [ ! -f "prisma/schema.prisma" ]; then
      echo "Initializing Prisma with TypeScript setup..."
      npx prisma init
      echo "Don't forget to configure your DATABASE_URL in .env"
    else
      echo "Prisma already initialized"
    fi
  '';

  scripts.setup-ts-prisma-project.exec = ''
    init-tsconfig
    init-prisma-ts

    echo ""
    echo "📝 Next steps:"
    echo "1. Configure your DATABASE_URL in .env"
    echo "2. Define your models in prisma/schema.prisma"
    echo "3. Run 'npx prisma generate' to generate the client"
    echo "4. Run 'npx prisma db push' to sync your database"
  '';

  # Optional: Enable postgres by default for TS+Prisma projects
  # services.postgres.enable = lib.mkDefault true;

  enterShell = lib.mkAfter ''
    combined-welcome
  '';
}
