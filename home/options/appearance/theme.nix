{ lib, config, ... }:

let
  inherit (lib) mkOption;
  inherit (lib.types) nullOr enum;
in

{
  options.ooknet.theme = mkOption {
    type = nullOr (enum [ "minimal" "phone" ]);
    default = null;
  };
}
