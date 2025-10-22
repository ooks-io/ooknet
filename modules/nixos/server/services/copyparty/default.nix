{
  inputs,
  inputs',
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (config.ooknet.server) services;
  inherit (config.age) secrets;
in {
  imports = [
    inputs.copyparty.nixosModules.default
  ];

  config = mkIf (elem "copyparty" services) {
    services.copyparty = {
      enable = true;
      package = inputs'.copyparty.packages.default;
      settings = {
        i = "127.0.0.1"; # default option, listen on local host
        p = 3923; # use default port for now
        e2dsa = true; # enable file indexing
        e2ts = true; # enable metadata indexing for media files
        ah-alg = "argon2";
      };

      accounts = {
        ooks = {
          passwordFile = "${secrets.ooks-copyparty.path}";
        };
      };

      volumes = {
        "/media" = {
          path = "/home/ooks/Media";
          access = {
            rw = "ooks";
          };
          flags = {
            e2d = true;
            scan = 300;
          };
        };
      };
    };
  };
}
