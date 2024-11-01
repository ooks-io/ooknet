{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf elem optionals;
  inherit (config.ooknet.server) services database;
in {
  config = mkIf database.postgresql.enable {
    services.postgresql = {
      enable = true;

      checkConfig = true;

      ensureDatabases = optionals (elem "forgejo" services) ["forgejo"];

      ensureUsers =
        [
          {
            name = "postgres";
            ensureClauses = {
              login = true;
              superuser = true;
              replication = true;
              createdb = true;
              createrole = true;
            };
          }
        ]
        ++ (optionals (elem "forgejo" services) [
          {
            name = "forgejo";
            ensureDBOwnership = true;
          }
        ]);
    };
  };
}
