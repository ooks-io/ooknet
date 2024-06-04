{ lib, ... }:

let
  inherit (lib) mkEnableOption;
in

{
  options.ooknet.communication = {
    discord.enable = mkEnableOption "";
  };
}
