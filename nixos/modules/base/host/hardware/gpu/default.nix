{ lib, ... }:

let
  inherit (lib) types mkOption;
in

{
  imports = [
    ./amd.nix
    ./intel.nix
    ./nvidia.nix
  ];

  options.ooknet.host.hardware.gpu.type = mkOption {
    type = with types; nullOr (enum ["intel" "amd" "nvidia"]);
    default = null;
    description = "Type of gpu system module to use";
  };
}
