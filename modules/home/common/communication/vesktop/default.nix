{
  osConfig,
  hozen,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (hozen) color;
  inherit (osConfig.ooknet.appearance) fonts;
  inherit (osConfig.ooknet.workstation) profiles;

  vesktopMime = {"x-scheme-handler/discord" = ["vesktop.desktop"];};
in {
  config = mkIf (elem "communication" profiles) {
    # <https://github.com/AlephNought0/Faery/blob/main/Home/Programs/Vesktop/patchedvesktop.patch>
    home.packages = [
      pkgs.vesktop
      #      pkgs.equibop
    ];

    xdg.configFile."vesktop/themes/nix.css".text =
      /*
      css
      */
      ''
        /**
         * @name Discord 1.6 (Gruvbox)
         * @author dom1torii
         * @description CS 1.6 + Old Steam Inspired Theme for Discord
         * @website https://github.com/dom1torii/discord16
         * @version 0.0.3
        */

        @import url("https://dom1torii.github.io/discord16/src/css/main.css");

        * {
          --font: "${fonts.monospace.family}"; /* Change to "" for default font */
          --rounded-avatars: false;
          --steam-logo: false;
        }

        * {
          --custom-bg: #${color.layout.menu};
          --custom-secondary-bg: #${color.layout.body};

          --custom-accent: #${color.primary.base};
          --custom-secondary-accent: #${color.primary.soft4};

          --dark-border: #${color.border.inactive};
          --light-border: #${color.border.active};

          --custom-text: #${color.typography.text};
          --custom-secondary-text: #${color.typography.text-bright};
        }
      '';

    ooknet.binds.discord = "vesktop";
    xdg.mimeApps = {
      associations.added = vesktopMime;
      defaultApplications = vesktopMime;
    };
  };
}
