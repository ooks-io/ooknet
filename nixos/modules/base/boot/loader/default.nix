{ lib, ... }:

let
  inherit (lib) types mkOption;
in

{
  imports = [
    ./systemd.nix
    # ./grub
  ];

  options.ooknet.boot.loader = mkOption {
    type = types.enum ["systemd" "grub"];
    default = "systemd";
  };
}
