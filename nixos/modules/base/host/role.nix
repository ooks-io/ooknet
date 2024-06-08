{ lib, ... }:

let
  inherit (lib) types mkOption;
in

{
  options.ooknet.host.function = mkOption {
    type = with types; listOf (enum ["gaming" "workstation" "media-server"]);
    default = [];
    description = "Host's primary function/s";
  };
}
