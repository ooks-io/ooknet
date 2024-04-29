{ lib, ... }:

let
  inherit (lib) types mkOption;
in

{
  imports = [
    ./gaming
    ./workstation
    ./media-server
  ];

  options.systemModules.host.function = mkOption {
    type = with types; listOf (enum ["gaming" "workstation" "media-server"]);
    default = [];
    description = "Host's primary function/s";
  };
}
