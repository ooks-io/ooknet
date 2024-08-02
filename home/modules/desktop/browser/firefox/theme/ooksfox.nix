{config, ...}: let
  inherit (config.colorscheme) pallete;
  inherit (config.ooknet.theme) fonts;
in
  /*
  css
  */
  ''
    /* minimal firefox css ooks  */

    /* ===== Color Variables and Root Styles ===== */
    :root {
      /* Base colors */
      --base00: #${pallete.base00}; /* ---- */
      --base01: #${pallete.base01}; /* --- */
      --base02: #${pallete.base02}; /* -- */
      --base03: #${pallete.base03}; /* - */
      --base04: #${pallete.base04}; /* + */
      --base05: #${pallete.base05}; /* ++ */
      --base06: #${pallete.base06}; /* +++ */
      --base07: #${pallete.base07}; /* ++++ */

      /* Accent colors */
      --base08: #${pallete.base08}; /* red */
      --base09: #${pallete.base09}; /* orange */
      --base0A: #${pallete.base0A}; /* yellow */
      --base0B: #${pallete.base0B}; /* green */
      --base0C: #${pallete.base0C}; /* aqua/cyan */
      --base0D: #${pallete.base0D}; /* blue */
      --base0E: #${pallete.base0E}; /* purple */
      --base0F: #${pallete.base0F}; /* brown */

      /* UI-specific colors */
      --toolbar-bgcolor: red;
      --tab-active-bg-color: red;

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
    #back-button,
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
    /* Style input box */
    moz-input-box {
      background: var(--base01) !important;
      color: var(--base07) !important;
      border: solid 1px var(--base05) !important;
    }

    /* Style input box */
    #urlbar-input-container {
      background: var(--base08) !important;
      color: var(--base07) !important;
      border: none !important;
      border-radius: 5 !important;
    }

    /* Hide URL bar go button */
    .urlbar-go-button { display: none !important; }

    /* Remove navigation bar background */
    #nav-bar.browser-toolbar { background: none !important; }

    /* Position and style navigation bar */
    #nav-bar {
      opacity: 0;
      text-align: center;
      position: fixed !important;
      border: solid 1px var(--nix-fg1) !important;
      top: 30px;
      left: 25%;
      right: 25%;
      z-index: 1;
    }

    /* Expand navigation bar on focus */
    #nav-bar:focus-within,
    #nav-bar:hover {
      opacity: 1;
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
      background: var(--base00) !important;
      padding-bottom:0 !important;
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
