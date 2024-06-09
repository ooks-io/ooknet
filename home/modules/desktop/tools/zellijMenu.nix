{ lib, config, inputs, pkgs, ... }:

let
  inherit (lib) mkIf;
  multiplexer = config.ooknet.console.multiplexer;
  launcher = config.ooknet.wayland.launcher;
in

{
  config = mkIf (multiplexer == "zellij" && launcher == "rofi") {
    home.packages = [ inputs.ooks-scripts.packages.${pkgs.system}.zellijmenu ];
    ooknet.binds.zellijMenu = "zellijMenu -n";
  };
}
