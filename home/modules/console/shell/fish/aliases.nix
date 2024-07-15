{ lib, config, osConfig, pkgs, ... }:

let
  inherit (lib) mkIf getExe;
  inherit (pkgs) bat eza dust nh;
  
  cfg = config.ooknet.shell.fish;
  admin = osConfig.ooknet.host.admin;
in

{
  config = mkIf (cfg.enable || admin.shell == "fish") {
    programs.fish = {
      shellAliases = {
        cat = "${getExe bat}";
        ls = "${getExe eza} -a --icons --group-directories-first";
        lst = "${getExe eza} -T -L 5 --icons --group-directories-first";
        du = "${getExe dust}";
      };
      shellAbbrs = {
        f = "cd $FLAKE";
        fe = "$EDITOR $FLAKE";

        nswitch = "${getExe nh} os switch";
      };
    };
  };
}
