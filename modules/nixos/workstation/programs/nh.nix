{
  lib,
  config,
  ...
}: let
  inherit (config.ooknet.host) role;
  inherit (lib) mkIf;
in {
  programs.nh = mkIf (role == "workstation") {
    enable = true;
  };
}
