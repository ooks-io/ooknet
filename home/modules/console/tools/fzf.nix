{ lib, config, osConfig, ... }:

let
  inherit (lib) mkIf;
  admin = osConfig.ooknet.host.admin;
  cfg = config.ooknet.tools.fzf;
in

{
  config = mkIf cfg.enable {
    fzf = {
      enable = true;
      enableFishIntegration = mkIf (admin.shell == "fish") true;
      defaultCommand = "rg --files --hidden";
      changeDirWidgetOptions = [
        "--preview 'eza --icons -L 3 -T --color always {} | head -200'"
        "--exact"
      ];
      fileWidgetCommand = "rg --files";
      fileWidgetOptions = [
        "--preview 'bat --color=always {}'"
      ];
    };
  };
}
