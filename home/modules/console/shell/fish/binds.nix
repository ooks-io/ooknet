{
  lib,
  config,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig.ooknet.host) admin;

  cfg = config.ooknet.shell.fish;
in {
  config = mkIf (cfg.enable || admin.shell == "fish") {
    programs.fish = {
      functions = {
        fish_user_key_bindings = ''
          bind --preset -M insert \cf nvim '+Telescope find_files' $FLAKE
          bind --preset -M insert \ec fzf_cd_widget
        '';
      };
    };
  };
}
