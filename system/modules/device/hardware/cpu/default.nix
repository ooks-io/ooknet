{ lib, ... }:

let
  inherit (lib) types mkOption;
in

{
  imports = [
    ./amd
    ./intel
  ];

  options.systemModules.hardware.cpu.type = mkOption {
    type = with types; nullOr (enum ["intel" "amd"]);
    default = null;
    description = "Type of cpu system module to use";
  };
}
