{ lib, config, ... }:
let
  cfg = config.profiles.base;
in
{
  imports = [
    ../../modules
    ../../secrets
  ];

  config = lib.mkIf cfg.enable {

    programs.home-manager.enable = true;

    xdg.portal.enable = true;

    homeModules = {
      sops.enable = true;

      config = {
        nix.enable = true;
        nixColors.enable = true;
        home.enable = true;
        userDirs.enable = true;
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
          transientServices.enable = true;
        };
      };
    };  
  };
}
