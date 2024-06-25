{
  pkgs,
  config,
  ...
}: {
  env.MJS_DB_USER = "devenv";
  env.MJS_DB_PASS = "secret";
  env.DATABASE_URL = "postgres://devenv@localhost/main";
  env.REDIS_URL = "redis://localhost:6379";
  env.MEDUSA_BACKEND_URL = "http://localhost:${config.env.PORT}";
  env.PORT = "9300";
  # env.PGUSER = "postgres";
  # env.PGPASS = "postgres";

  # env.ADYEN_API_KEY = "";
  # env.ADYEN_CLIENT_KEY = "";
  # env.ADYEN_HMAC_KEY = "";
  # env.ADYEN_MERCHANT_ACCOUNT = "";

  packages = [
    pkgs.supabase-cli
    pkgs.docker-compose
    pkgs.deno
    pkgs.pgcli
    pkgs.stripe-cli
  ];

  enterShell = ''
  '';

  # programs.podman.enable = true;
  services.postgres = {
    enable = true;
    package = pkgs.postgresql_15;
    listen_addresses = "127.0.0.1";
    # initialDatabases = [{name = "main";}];
    # extensions = extensions: [
    #   extensions.postgis
    #   # extensions.timescaledb
    #   extensions.pg_cron
    # ];
    # settings.shared_preload_libraries = "timescaledb";
    # initialScript = ''
    #   CREATE USER postgres WITH SUPERUSER LOGIN;
    #   # CREATE EXTENSION IF NOT EXISTS timescaledb;
    #   CREATE USER ${config.env.MJS_DB_USER} WITH SUPERUSER PASSWORD '${config.env.MJS_DB_PASS}';
    #   CREATE DATABASE main;
    #   -- GRANT ALL PRIVILEGES ON main.* TO ${config.env.MJS_DB_USER};
    # '';
  };
  services.redis = {
    enable = true;
  };
  services.minio = {
    enable = true;
    buckets = ["medusa"];
  };

  # https://devenv.sh/languages/
  languages.javascript = {
    enable = true;
    package = pkgs.nodejs_20;
    # pnpm.install = true;
  };
  programs.pnpm.enable = true;
  # processes.medusa-front.exec = "pnpm -C medusa-storefront dev";
  processes.medusa-store.exec = "pnpm -C medusa dev";
}
