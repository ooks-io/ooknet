{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.ooknet.shell.zsh;
  inherit (osConfig.ooknet.host) admin;
in {
  config = mkIf (cfg.enable || admin.shell == "zsh") {
    programs.zsh.plugins = [
      {
        name = "fast-syntax-highlighting";
        file = "fast-syntax-highlighting";
        src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
      }
      {
        name = "zsh-autopair";
        file = "autopair.zsh";
        src = "${pkgs.zsh-autopair}/share/zsh/zsh-autopair";
      }
    ];
  };
}
