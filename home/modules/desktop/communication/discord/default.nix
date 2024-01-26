{ config, lib, pkgs, ... }:

let
  cfg = config.homeModules.desktop.communication.discord;
  inherit (config.colorscheme) colors;
in

{
  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.vesktop ];

    xdg.configFile."vesktop/themes/nix.css".text = /* css */ ''
      /**
        * @name nix-colors-minimal
        * @author aoku
        * @description minimal theme designed with nix colors
      */
  
      :root {
        --nix-bg1: #${colors.base00}; 
        --nix-bg2: #${colors.base01};
        --nix-bg3: #${colors.base02};
    
        --nix-fg1: #${colors.base05};
        --nix-fg2: #${colors.base07};
        --nix-fg3: #${colors.base03};
        --nix-link: #${colors.base0D};

        --nix-accent: #${colors.base08};
        --nix-hi: #${colors.base0B}; 

        --font-mono: ${config.fontProfiles.monospace.family}, monospace;
        --font-regular: ${config.fontProfiles.regular.family}, sans serif;

        /* server collapse */
        --sb-collapsed-width: 12px;
        --sb-transition-duration: 0s;
      }

      .theme-dark {
        --background-primary: var(--nix-bg1);
        --background-secondary: var(--nix-bg1);
        --background-secondary-alt: var(--nix-bg1);
        --background-accent: var(--nix-accent);
        --background-tertiary: var(--nix-bg1);
        --background-floating: var(--nix-bg1);
        --background-mentioned: var(--nix-bg1);
        --background-mentioned-hover: var(--nix-bg1);
        --background-mobile: var(--nix-bg1);
        --background-mobile-secondary: var(--nix-bg2);
        --background-modifier-selected: var(--nix-bg1);
        --channeltextarea-background:var(--nix-bg1);
        --background-modifier-hover:var(--nix-bg1);
        --activity-card-background: var(--nix-bg2);

        --header-primary: var(--nix-fg2);
        --header-secondary: var(--nix-fg1);
      
        --text-normal: var(--nix-fg1);
        --text-muted: var(--nix-fg1);
        --text-link: var(--nix-link);
        --text-warning: var(--nix-accent);
        --font-primary: var(--font-mono);
        --font-headline: var(--font-mono);
        --font-display: var(--font-mono);
      
        --interactive-normal: var(--nix-fg1); /*base05*/
        --interactive-hover: var(--nix-hi); /*base0B*/
        --interactive-active: var(--nix-fg2);
        --interactive-muted: var(--nix-fg3); /*base03*/
        --channels-default: var(--nix-fg1);
      
        --scrollbar-thin-thumb: transparent;
        --scrollbar-thin-track: transparent;
        --scrollbar-auto-thumb: var(--nix-fg1);
        --scrollbar-auto-track:var(--nix-bg1);
        --scrollbar-auto-scrollbar-color-thumb: var(--nix-accent);
      }

      .messagesWrapper_ea2b0b {
          font-family: var(--font-regular);
      }

      .titleWrapper__482dc {
        font-family: var(--font-mono);
      }

      .link__95dc0 /* text channel*/{
        border-radius: 0px;
        margin-left: -10px;
        font-family: var(--font-mono);
      }

      .container_ca50b9 .avatar_f8541f { /*avatar*/
        display: none;
      }

      .form__13a2c /* text input box resize */ {
        height: 50px;
        font-family: var(--font-regular);
      }

      .containerDefault__3187b .wrapper__7bcde:before /* text channel */{
        content: "";
        display:inline-block;
        background: var(--nix-hi);
        height: 100%;
        position: absolute;
        left: 0;
      }


      /* server collapse */
      .guilds__2b93a /* servers */{
          overflow: hidden !important;
          width: var(--sb-collapsed-width, 75px);
          transition: width var(--sb-transition-duration);
      }
      .guilds__2b93a:hover /* expand server bar on hover */{
          width: 70px;
          overflow: visible !important;
          animation: server-bar-overflow 0s linear 0ms forwards
      }
      .guilds__2b93a ~ .base__3e6af /* friends list, chat */{
          position: absolute;
          left: var(--sb-collapsed-left, var(--sb-collapsed-width));
          top: var(--sb-collapsed-top, 0px);
          bottom: var(--sb-collapsed-bottom, 0px);
          right: var(--sb-collapsed-right, 0px);
          transition-property: var(--sb-transition-property, left);
          transition-duration: var(--sb-transition-duration);
      }
      .guilds__2b93a:hover ~ .base__3e6af /* friends list, chat */{
          position: absolute;
          left: var(--sb-left, 70px);
          top: var(--sb-top, 0px);
          bottom: var(--sb-bottom, 0px);
          right: var(--sb-right, 0px);
      }
      @keyframes server-bar-overflow{
          from{
              overflow: hidden;
          }
          to{
              overflow: visible;
          }
      }
    '';
  };
}
