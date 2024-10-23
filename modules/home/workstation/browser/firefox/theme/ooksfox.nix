{
  palette,
  fonts,
  ...
}:
with palette;
#css
  ''
      /* minimal firefox css ooks  */

      /* ===== Color Variables and Root Styles ===== */
      :root {
        /* Fonts */
        --font-mono: ${fonts.monospace.family}, monospace;
        }

      /* ===== General UI Modifications ===== */
      /* Hide status panel */
      #statuspanel { display: none !important; }

      /* Remove border radius from menus */
      menupopup, panel { --panel-border-radius: 0px !important; }
      menu, menuitem, menucaption { border-radius: 0px !important; }

      /* Hide navigation context menu items */
      menupopup > #context-navigation,
      menupopup > #context-sep-navigation { display: none !important; }

      /* Hide various toolbar buttons */
      #forward-button,
      #reload-button,
      #stop-button,
      #home-button,
      #library-button,
      #PanelUI-button,
      #unified-extensions-button,
      #star-button,
      #reader-mode-button,
      #save-to-pocket-button,
      #tracking-protection-icon-container,
      #page-action-buttons,
      #fxa-toolbar-menu-button,
      #identity-box { display: none !important; }

      /* Hide customizable UI springs */
      #customizableui-special-spring1,
      #customizableui-special-spring2 { display: none; }

      /* Hide Personal Toolbar */
      #PersonalToolbar { display: none !important; }

      /* ===== URL Bar Styling ===== */

      #urlbar-container {
        margin-left: 0 !important;
        margin-right: 0 !important;
        padding-top: 0 !important;
        padding-bottom: 0!important;
      }

      #urlbar-background {
        border: solid 1px !important;
        border-radius: 0 !important;
        outline: none !important;
        background: #${crust} !important;
      }

      #navigator-toolbox {
        border: none !important;
        border-bottom: solid 1px !important;\
      }

      /* Hide URL bar go button */
      .urlbar-go-button { display: none !important; }

      /* Remove navigation bar background */
      #nav-bar.browser-toolbar { background: none !important; }

      /* Position and style navigation bar */

      #nav-bar {
        text-align: center;
        min-height: 0 !important;
        max-height: 0 !important;
        height: 0 !important;
      }

    /* Expand navigation bar on focus */
      #nav-bar:focus-within {
        max-height: 40px !important;
        height: 60px !important;
        min-height: 15px !important;
      }

      /* ===== Tab Bar Styling ===== */
      /* Hide title bar buttons and spacer */
      .titlebar-close,
      .titlebar-spacer { display: none !important; }

      /* Remove tab margin */
      #titlebar {
        --proton-tab-block-margin: 0px !important;
        --tab-block-margin: 0px !important;
      }

      /* Remove tab shadows */
      #tabbrowser-tabs:not([noshadowfortests]) .tab-background:is([selected], [multiselected]) {
        box-shadow: none !important;
      }

      /* Hide tab-related buttons */
      #alltabs-button,
      #tabs-newtab-button,
      #firefox-view-button,
      #new-tab-button,
      .tab-close-button { display: none !important; }

      /* Style tabs */
      tab {
        font-family: var(--font-mono);
        font-weight: bold;
      }

      /* Set tab and tab bar height */
      #TabsToolbar, .tabbrowser-tab {
        max-height: 35px !important;
        background: #${crust} !important;
        border: none;
      }

      /* Center tabs when not overflowing */
      #tabbrowser-arrowscrollbox:not([overflowing]) {
        --uc-flex-justify: center;
      }

      scrollbox[orient="horizontal"] {
        justify-content: var(--uc-flex-justify, initial);
      }

      /* Style selected tabs */
      #tabbrowser-tabs .tabbrowser-tab[selected] .tab-content {
        border: solid 1px var(--base05) !important;
        color: var(--base07);
        background: var(--base02)
      }

      /* Style non-selected tabs */
      tab:not([selected="true"]) {
        /* border: solid 1px var(--base05) !important; */
        background: var(--base01) !important;
      }
  ''
