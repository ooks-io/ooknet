{ lib, config, ... }:
let
  cfg = config.profiles.base;
  inherit (lib) mkDefault;
in
{
  imports = [
    ../../modules
  ];

  config = lib.mkIf cfg.enable {

    systemd.user.startServices = mkDefault "sd-switch";

    ooknet = {
      config = {
        home.enable = true;
        userDirs.enable = true;
        mimeApps.enable = true;
      };

      console = {
        editor.helix = {
          enable = true;
          default = true;
        };
        prompt.starship.enable = true;
        shell = {
          fish.enable = true;
          bash.enable = true;
        };
        multiplexer.zellij.enable = true;
        utility = {
          ssh.enable = true;
          nixIndex.enable = true;
          git.enable = true;
          tools.enable = true;
        };
      };
    };  
  };
}
