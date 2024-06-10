{ lib, ... }:

let
  inherit (lib) mkEnableOption;
in

{
  options.ooknet.productivity = {
    notes = {
      obsidian.enable = mkEnableOption "";
    };
    office = {
      libreoffice.enable = mkEnableOption "";
    };
    pdf = {
      zathura.enable = mkEnableOption "";
    };
  };
}
