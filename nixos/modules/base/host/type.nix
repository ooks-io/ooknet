{ lib, ... }:

let
  inherit (lib) mkOption types;
in

{
  options.ooknet.host.type = mkOption {
    type = types.enum ["desktop" "laptop" "mixed" "server" "phone" "laptop" "micro" "vm"];
    default = "";
    description = "Declare what type of device the host is";
  };  
}
