{ pkgs, lib, inputs, config, ... }:

let
  addons = inputs.firefox-addons.packages.${pkgs.system};
  cfg = config.ooknet.browser.firefox;
  browser = config.ooknet.desktop.browser;
  inherit (lib) mkIf;
in
{

  config = mkIf (cfg.enable || browser == "firefox") {
    home.sessionVariables.BROWSER = mkIf (browser == "firefox") "firefox";
    ooknet.binds.browser = mkIf (browser == "firefox") "firefox";
  
    programs.firefox = {
      enable = true;
      profiles.ooks = {
        extensions = with addons; [
          ublock-origin
          darkreader
          tridactyl
          # onepassword-password-manager # cannot get this to work unfree issue.
        ];
        settings = import ./settings/ooksJs.nix;
        userChrome = import ./theme/penguinFox.nix;
        userContent = import ./theme/penguinFoxContent.nix;
      };
    };
  };
}
