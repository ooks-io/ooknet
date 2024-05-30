{ lib, config, inputs, ... }:

let
  cfg = config.ooknet.desktop.wayland.bar.ags;
in

{

  imports = [ inputs.ags.homeManagerModules.default ];

  config = lib.mkIf cfg.enable {
    programs.ags = {
      enable = true;
    };
  };
}
