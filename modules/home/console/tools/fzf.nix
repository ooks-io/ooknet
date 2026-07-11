{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig.ooknet.host) admin;
  cfg = osConfig.ooknet.console.tools.fzf;
in {
  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      enableFishIntegration = mkIf (admin.shell == "fish") true;
      defaultCommand = "rg --files --hidden";
      changeDirWidget.options = [
        "--preview 'eza --icons -L 3 -T --color always {} | head -200'"
        "--exact"
      ];
      fileWidget = {
        command = "rg --files";
        options = [
          "--preview 'bat --color=always {}'"
        ];
      };
    };
  };
}
