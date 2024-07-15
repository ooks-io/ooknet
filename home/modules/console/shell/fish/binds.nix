{ lib, config, osConfig, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.shell.fish;
  admin = osConfig.ooknet.host.admin;
in

{
  config = mkIf (cfg.enable || admin.shell == "fish") {
    programs.fish.functions = {
      fish_user_key_bindings = ''
        bind --preset -M insert \cf fe
        bind --preset -M insert \ec fzf_cd_widget
      '';
    };
  };
}
