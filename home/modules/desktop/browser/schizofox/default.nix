{ inputs, config, lib, ... }:

let
  cfg = config.homeModules.desktop.browser.schizofox;
  inherit (config.colorscheme) colors;
in

{
  imports = [inputs.schizofox.homeManagerModule];

  config = lib.mkIf cfg.enable {
    home.sessionVariables.BROWSER = lib.mkIf cfg.default "firefox";
    programs.schizofox = {
      enable = true;
      theme = {
        font = "${config.fontProfiles.regular.family}";
        colors = {
          background-darker = "${colors.base00}";
          background = "${colors.base01}";
          foreground = "${colors.base07}";
        };
      };
      
      security = {
        sanitizeOnShutdown = false;
        sandbox = true;
        noSessionRestore = false;
        userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:106.0) Gecko/20100101 Firefox/106.0";
      };

      misc = {
        drmFix = true;
        disableWebgl = false;
      };

      extensions = {
        extraExtensions = let
          mkUrl = name: "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
          extensions = [
            {
              id = "1018e4d6-728f-4b20-ad56-37578a4de76";
              name = "flagfox";
            }
            {
              id = "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}";
              name = "auto-tab-discard";
            }
            {
              id = "{d634138d-c276-4fc8-924b-40a0ea21d284}";
              name = "1password-x-password-manager";
            }
            {
              id = "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}";
              name = "refined-github-";
            }
            {
              id = "sponsorBlocker@ajay.app";
              name = "sponsorblock";
            }
            {
              id = "{tridactyl.vim@cmcaine.co.uk}";
              name = "tridactyl-vim";
            }
          ];
          extraExtensions = builtins.foldl' (acc: ext: acc // {ext.id = {install_url = mkUrl ext.name;};}) {} extensions;
        in
          extraExtensions;
      };
    };
  };
}
