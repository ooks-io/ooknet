{ lib, config, inputs, pkgs, ... }:

let
  inherit (lib) mkIf;
  launcher = config.ooknet.wayland.launcher;
in


{
  config = mkIf (launcher == "rofi") {
    home.packages = [ inputs.ooks-scripts.packages.${pkgs.system}.powermenu ];
    ooknet.binds.powermenu = "powermenu -c dmenu";
  };
}
