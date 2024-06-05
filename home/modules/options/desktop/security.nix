{ lib, ... }:

let
  inherit (lib) mkOption types;
  inherit (types) nullOr enum;
in

{
  options.ooknet.security.polkit = mkOption {
    type = nullOr (enum ["gnome" "pantheon"]); # TODO: add kde agent
    default = "gnome";
    description = "Type of polkit agent module to use";
  };
}
