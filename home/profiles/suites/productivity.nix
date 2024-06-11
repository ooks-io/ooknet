{ osConfig, lib, ... }:

let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  profiles = osConfig.ooknet.host.profiles;
in

{
  config = mkIf (elem "productiviy" profiles) {
    ooknet.productivity = {
      notes.obsidian.enable = true;
      office.libreoffice.enable = true;
      pdf.zathura.enable = true;
    };
  };
}
