{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf elem optionals;
  inherit (config.ooknet.server) services database;
in {
  config = mkIf database.postgresql {
    services.postgresql = {
      enable = true;
      ensureDatabases = optionals (elem "forgejo" services) ["forgejo"];
      ensureUsers = optionals (elem "forgejo" services) [
        {
          name = "forgejo";
          ensurePermissions = {
            "DATABASE forgejo" = "ALL PRIVILEGES";
          };
        }
      ];
    };
  };
}

