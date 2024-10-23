{
  lib,
  config,
  osConfig,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (osConfig.ooknet.host) admin;

  cfg = config.ooknet.home.zsh;
in {
  imports = [
    ./plugins.nix
  ];

  options.ooknet.home.zsh.enable = mkEnableOption "";

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
