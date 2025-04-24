{config, ...}: let
  inherit (config.ooknet) host;
in {
  networking = {
    computerName = host.name;
  };
}
