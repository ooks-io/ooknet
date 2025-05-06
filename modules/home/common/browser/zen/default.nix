{
  pkgs,
  lib,
  inputs',
  config,
  osConfig,
  hozen,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  inherit (osConfig.ooknet.appearance) fonts;
  inherit (hozen) color;
  inherit (osConfig.ooknet.workstation) default;
  inherit (pkgs.stdenv) isDarwin;

  addons = inputs'.firefox-addons.packages;
  cfg = osConfig.ooknet.workstation.programs.zen;
  zenMime = {
    "text/html" = ["zen-beta.desktop"];
    "x-scheme-handler/http" = ["zen-beta.desktop"];
    "x-scheme-handler/https" = ["zen-beta.desktop"];
    "x-scheme-handler/ftp" = ["zen-beta.desktop"];
    "x-scheme-handler/about" = ["zen-beta.desktop"];
    "x-scheme-handler/unknown" = ["zen-beta.desktop"];
    "application/x-extension-htm" = ["zen-beta.desktop"];
    "application/x-extension-html" = ["zen-beta.desktop"];
    "application/x-extension-shtml" = ["zen-beta.desktop"];
    "application/xhtml+xml" = ["zen-beta.desktop"];
    "application/x-extension-xhtml" = ["zen-beta.desktop"];
    "application/x-extension-xht" = ["zen-beta.desktop"];
    "application/json" = ["zen-beta.desktop"];
  };
in {
  imports = [
    inputs.zen-browser.homeModules.beta
  ];
  config = mkMerge [
    (mkIf (cfg.enable || default.browser == "zen") {
      programs.zen-browser = {
        # FIXME: write your own zen module...
        enable = !isDarwin;
        profiles.${config.home.username} = {
          id = 0;
          isDefault = true;
          extensions.packages = with addons; [
            ublock-origin
            # FIXME: dont use nur...
            (onepassword-password-manager.overrideAttrs
              (_: {meta.license = lib.licenses.mit;}))
          ];
          settings = {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "zen.urlbar.behavior" = "float";
            "zen.theme.border-radius" = 0;
            "zen.view.compact.hide-tabbar" = true;
            "zen.view.compact.hide-toolbar" = true;
            "zen.view.experimental-rounded-view" = false;
            "zen.workspace.show-workspace-indicator" = false;
          };
          userChrome = import ./userChrome.nix {inherit color fonts;};
        };
      };
    })

    (mkIf (default.browser == "zen" && !isDarwin) {
      home.sessionVariables.BROWSER = "zen";
      ooknet.binds.browser = "zen";
      xdg.mimeApps = {
        associations.added = zenMime;
        defaultApplications = zenMime;
      };
    })
    (mkIf (default.browser == "zen" && isDarwin) {
      home.file."Library/Application Support/zen/profiles/ooks/chrome/userChrome.css" = {
        text = import ./userChrome.nix {inherit color fonts;};
      };
    })
  ];
}
