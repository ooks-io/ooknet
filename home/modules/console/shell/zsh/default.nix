{ lib, config, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.ooknet.console.shell.zsh;
in

{
  options.ooknet.console.shell.zsh.enable = mkEnableOption "";

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      autocd = true;
      dotDir = ".config/zsh";
    };
  };
}
