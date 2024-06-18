{ lib, config, ... }:

let
  inherit (lib) mkIf;
  inherit (config.colorscheme) palette; 

  cfg = config.ooknet.browser.firefox;
  browser = config.ooknet.desktop.browser;
  fonts = config.ooknet.fonts;
  
in

{
  config = mkIf (browser == "firefox" || cfg.enable) {
    xdg.configFile = {
      "tridactyl/tridactylrc".text = ''
        set searchurls.nix https://sourcegraph.com/search?q=context:global+lang:nix %s
      '';

      # theme based off base16 themes
      # source: <https://github.com/bezmi/base16-tridactyl>
      "tridactyl/themes/ooknet.css".text = /* css */ ''
        :root {
          --font: ${fonts.monospace.family};
          --bg: #${palette.base00};
          --fg: #${palette.base05};
          --red: #${palette.base08};
          --green: #${palette.base0B};
          --blue: #${palette.base0D};
          --yellow: #${palette.base0A};
          --purple: #${palette.base0E};
          --orange: #${palette.base09};
          --cyan: #${palette.base0C};
          --comment: #${palette.base04};
          --selectedline: #${palette.base02};


          --tridactyl-fg: var(--fg);
          --tridactyl-bg: var(--bg);

          --tridactyl-url-fg: var(--green);
          --tridactyl-url-bg: var(--bg);
          
          --tridactyl-highlight-box-bg: var(--selectedline);
          --tridactyl-highlight-box-fg: var(--fg);

          --tridactyl-of-fg: var(--fg);
          --tridactyl-of-bg: var(--selectedline);

          --tridactyl-cmdl-fg: var(--bg);
          --tridactyl-cmdl-font-family: var(--selectedline);

          --tridactyl-cmplt-font-family: var(--font);
          
          --tridactyl-hintspan-font-family: var(--font);
          --tridactyl-hintspan-fg: var(--bg) !important;
          --tridactyl-hintspan-bg: var(--orange) !important;

          --tridactyl-hint-active-fg: none;
          --tridactyl-hint-active-bg: var(--tridactyl-bg);
          --tridactyl-hint-active-outline: var(--green);
          --tridactyl-hint-bg: none;
          --tridactyl-hint-outline: none;
        } 

        #tridactyl-colon::before {
          content: " ";
          font-family: var(--font);
          font-size: 1.5rem;
          color: var(--green);
          display: inline;
          margin-left: 15px;
        }

        #command-line-holder {
          order: 1;
          display: flex;
          justify-content: center;
          align-items: center;
          border: 2px solid var(--tridactyl-fg);
          background: var(--tridactyl-bg);
        }

        #tridactyl-input {
          padding: 1rem;
          color: var(--tridactyl-fg);
          width: 90%;
          font-family: var(--font);
          font-size: 1.5rem;
          line-height: 1.5;
          background: var(--tridactyl-bg);
          padding-left: unset;
          padding: 1rem;
        }


        #completions table {
          font-size: 0.8rem;
          font-weight: 200;
          border-spacing: 0;
          table-layout: fixed;
          padding: 1rem;
          padding-top: 1rem;
          padding-bottom: 1rem;
        }

        #completions > div {
          max-height: calc(20 * var(--option-height));
          min-height: calc(10 * var(--option-height));
        }

        #completions {
          --option-height: 1.4em;
          color: var(--tridactyl-fg);
          background: var(--tridactyl-bg);
          display: inline-block;
          font-size: unset;
          font-weight: 200;
          overflow: hidden;
          width: 100%;
          border-top: unset;
          order: 2;
        }

        #completions .HistoryCompletionSource {
          max-height: unset;
          min-height: unset;
        }

        #completions .HistoryCompletionSource table {
          width: 100%;
          font-size: 9pt;
          border-spacing: 0;
          table-layout: fixed;
        }

        #completions .BmarkCompletionSource {
          max-height: unset;
          min-height: unset;
        }

        #completions table tr td.prefix,
        #completions table tr td.privatewindow,
        #completions table tr td.container,
        #completions table tr td.icon {
          display: none;
        }

        #completions .BufferCompletionSource table {
          width: unset;
          font-size: unset;
          border-spacing: unset;
          table-layout: unset;
        }

        #completions table tr .title {
          width: 50%;
        }

        #completions table tr {
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
        }

        #completions .sectionHeader {
          background: unset;
          font-weight: bold;
          border-bottom: unset;
          padding: 1rem !important;
          padding-left: unset;
          padding-bottom: 0.2rem;
        }

        #cmdline_iframe {
          position: fixed !important;
          bottom: unset;
          top: 25% !important;
          left: 10% !important;
          z-index: 2147483647 !important;
          width: 80% !important;
          box-shadow: rgba(0, 0, 0, 0.5) 0px 0px 20px !important;
        }

        .TridactylStatusIndicator {
          position: fixed !important;
          bottom: 0 !important;
          background: var(--tridactyl-bg) !important;
          border: unset !important;
          border: 1px var(--green) solid !important;
          font-size: 12pt !important;
          padding: 0.8ex !important;
        }

        #completions .focused {
          background: var(--green);
          color: var(--bg);
        }

        #completions .focused .url {
          background: var(--green);
          color: var(--bg);
        }
      '';
    };
  };
}
