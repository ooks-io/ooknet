{
  config,
  pkgs,
  ...
}: let
  inherit (config.ooknet.host) admin;
in {
  environment = {
    shells = [
      pkgs.${admin.shell}
    ];
  };
}
