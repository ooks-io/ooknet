{ pkgs, lib, inputs, config, ... }:

let
  addons = inputs.firefox-addons.packages.${pkgs.system};
  cfg = config.ooknet.desktop.browser.firefox;
  inherit (lib) mkIf;
in
{

  config = {
    nixpkgs.config.allowUnfree = true;
    home.sessionVariables = mkIf cfg.default {
      BROWSER = "firefox";
    };
  
    programs.firefox = mkIf cfg.enable {
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
