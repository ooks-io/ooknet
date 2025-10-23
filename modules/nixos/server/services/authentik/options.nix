{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption mkEnableOption elem types;
  inherit (config.ooknet.server) services domain;
  authentikEnabled = elem "authentik" services;
in {
  options.ooknet.server.authentik = {
    enable = mkEnableOption "Authentik SSO" // {default = authentikEnabled;};

    domain = mkOption {
      type = types.str;
      default = "auth.${domain}";
      description = "Domain for Authentik portal";
    };

    port = mkOption {
      type = types.port;
      default = 9000;
      description = "Port for Authentik server";
    };

    stateDir = mkOption {
      type = types.path;
      default = "/var/lib/authentik";
      description = "State directory for Authentik";
    };

    postgres = {
      port = mkOption {
        type = types.port;
        default = 5432;
        description = "PostgreSQL port";
      };

      database = mkOption {
        type = types.str;
        default = "authentik";
      };

      user = mkOption {
        type = types.str;
        default = "authentik";
      };
    };

    redis = {
      port = mkOption {
        type = types.port;
        default = 6380;
        description = "Redis port for Authentik";
      };
    };
  };
}
