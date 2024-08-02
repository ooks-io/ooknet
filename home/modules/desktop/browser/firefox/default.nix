{
  pkgs,
  lib,
  inputs,
  config,
  osConfig,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  fonts = config.ooknet.fonts;
  palette = config.colorscheme.palette;

  addons = inputs.firefox-addons.packages.${pkgs.system};
  cfg = config.ooknet.browser.firefox;
  browser = config.ooknet.desktop.browser;
  admin = osConfig.ooknet.host.admin;
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
    (mkIf (cfg.enable || browser == "firefox") {
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
          userChrome = import ./theme/ooksfox.nix {inherit fonts palette;};
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

    (mkIf (browser == "firefox") {
      home.sessionVariables.BROWSER = "firefox";
      ooknet.binds.browser = "firefox";
      xdg.mimeApps = {
        associations.added = firefoxMime;
        defaultApplications = firefoxMime;
      };
    })
  ];
}
