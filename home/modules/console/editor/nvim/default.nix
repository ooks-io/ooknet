{ config, lib, inputs, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.editor.nvim;
  console = config.ooknet.console;

  ookvim = inputs.ookvim.packages.${pkgs.system}.default;
in
  
{
  
  config = mkIf (cfg.enable || console.editor == "nvim") {
    home.packages = [ ookvim ];
  };
}
