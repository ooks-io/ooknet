{ lib, config, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.homeModules.console.shell.zsh;
in

{
  options.homeModules.console.zsh.enable = mkEnableOption "";

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      autocd = true;
      dotDir = ".config/zsh";
    };
  };
}
