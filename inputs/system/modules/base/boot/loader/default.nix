{ lib, ... }:

let
  inherit (lib) types mkOption;
in

{
  imports = [
    ./systemd
    # ./grub
  ];

  options.systemModules.boot.loader = mkOption {
    type = types.enum ["systemd" "grub"];
    default = "systemd";
  };
}
