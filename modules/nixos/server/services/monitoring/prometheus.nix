{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (config.ooknet.server) services;
in {
  config = mkIf (elem "monitoring" services) {
    services.prometheus = {
      enable = true;
      port = 9090;

      scrapeConfigs = [
        {
          job_name = "ooksmedia";
          static_configs = [{
            targets = ["localhost:9100"];
            labels = {
              host = "ooksmedia";
            };
          }];
        }
        {
          job_name = "ooknode";
          static_configs = [{
            targets = ["ooknode.taila3ca6.ts.net:9100"];
            labels = {
              host = "ooknode";
            };
          }];
        }
        {
          job_name = "caddy";
          static_configs = [{
            targets = ["ooknode.taila3ca6.ts.net:2019"];
            labels = {
              host = "ooknode";
              service = "caddy";
            };
          }];
        }
      ];
    };
  };
}
