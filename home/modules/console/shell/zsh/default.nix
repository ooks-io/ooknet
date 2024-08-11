{
  lib,
  config,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.ooknet.shell.zsh;
  inherit (osConfig.ooknet.host) admin;
in {
  imports = [
    ./plugins.nix
  ];

  config = mkIf (cfg.enable || admin.shell == "zsh") {
    programs.zsh = {
      enable = true;
      autocd = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      dotDir = ".config/zsh";
      history = {
        expireDuplicatesFirst = true;
        path = "${config.xdg.dataHome}/zsh_history";
      };
    };
  };
}
