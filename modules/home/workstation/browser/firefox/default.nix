{
  pkgs,
  lib,
  inputs',
  osConfig,
  hozen,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  inherit (osConfig.ooknet.host) admin;
  inherit (osConfig.ooknet.appearance) colorscheme fonts;
  inherit (colorscheme) palette;
  inherit (osConfig.ooknet.workstation) default;

  addons = inputs'.firefox-addons.packages;
  cfg = osConfig.ooknet.workstation.programs.firefox;
  firefoxMime = {
    "text/html" = ["firefox.desktop"];
    "x-scheme-handler/http" = ["firefox.desktop"];
    "x-scheme-handler/https" = ["firefox.desktop"];
    "x-scheme-handler/ftp" = ["firefox.desktop"];
    "x-scheme-handler/about" = ["firefox.desktop"];
    "x-scheme-handler/unknown" = ["firefox.desktop"];
    "application/x-extension-htm" = ["firefox.desktop"];
    "application/x-extension-html" = ["firefox.desktop"];
    "application/x-extension-shtml" = ["firefox.desktop"];
    "application/xhtml+xml" = ["firefox.desktop"];
    "application/x-extension-xhtml" = ["firefox.desktop"];
    "application/x-extension-xht" = ["firefox.desktop"];
    "application/json" = ["firefox.desktop"];
  };
in {
  imports = [./tridactyl.nix];
  config = mkMerge [
    (mkIf (cfg.enable || default.browser == "firefox") {
      programs.firefox = {
        enable = true;
        nativeMessagingHosts = [pkgs.tridactyl-native];
        profiles.${admin.name} = {
          id = 0;
          isDefault = true;
          extensions = with addons; [
            ublock-origin
            darkreader
            tridactyl
            # onepassword-password-manager # cannot get this to work unfree issue.
          ];
          settings = import ./settings/ooksJs.nix;
          userChrome = import ./theme/ooksfox.nix {inherit fonts hozen;};
          userContent = import ./theme/penguinFoxContent.nix;
        };
        profiles.testing = {
          id = 1;
          extensions = with addons; [
            ublock-origin
            tridactyl
            darkreader
          ];
        };
      };
    })

    (mkIf (default.browser == "firefox") {
      home.sessionVariables.BROWSER = "firefox";
      ooknet.binds.browser = "firefox";
      xdg.mimeApps = {
        associations.added = firefoxMime;
        defaultApplications = firefoxMime;
      };
    })
  ];
}
