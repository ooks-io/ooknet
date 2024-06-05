{ lib, config, osConfig, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.shell.zsh;
  admin = osConfig.ooknet.host.admin;
in

{
  config = mkIf (cfg.enable || admin.shell == "zsh") {
    programs.zsh = {
      enable = true;
      autocd = true;
      dotDir = ".config/zsh";
    };
  };
}
