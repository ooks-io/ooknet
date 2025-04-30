{
  color,
  fonts,
  ...
}:
# css
''
    @media (prefers-color-scheme: dark) {
    :root {

      --clr-menu: #${color.layout.menu};
      --clr-bg: #${color.layout.body};
      --clr-fg: #${color.typography.text};
      --clr-inactive: #${color.border.inactive};
      --clr-border-active: #${color.border.active};
      --clr-border-inactive: #${color.border.inactive};
      --clr-secondary: #${color.secondary.base};
      --clr-primary: #${color.primary.base};

      --border-active: 1px var(--clr-border-active) solid;
      --border-inactive: 1px var(--clr-border-inactive) solid;

      --font-base: ${fonts.monospace.family};

      --zen-colors-primary: var(--clr-menu) !important;
      --zen-primary-color: var(--clr-primary) !important;
      --zen-colors-secondary: var(--clr-secondary) !important;
      --zen-colors-tertiary: var(--clr-menu) !important;
      --zen-colors-border: var(--clr-fg) !important;
      --toolbarbutton-icon-fill: var(--clr-fg) !important;
      --lwt-text-color: var(--clr-fg) !important;
      --toolbar-field-color: var(--clr-fg) !important;
      --tab-selected-textcolor: var(--clr-fg) !important;
      --toolbar-field-focus-color: var(--clr-fg) !important;
      --toolbar-color: #cdd6f4 !important;
      --newtab-text-primary-color: var(--clr-primary) !important;

      --toolbarbutton-icon-fill: var(--clr-fg) !important;

      /* Application Menu ( ... ) */
      --arrowpanel-color: var(--clr-fg) !important;
      --arrowpanel-background: var(--clr-menu) !important;


      --sidebar-text-color: yellow !important;
      --lwt-sidebar-text-color: purple!important;
      --lwt-sidebar-background-color: green !important;
      --toolbar-bgcolor: green !important;
      --newtab-background-color: var(--clr-menu) !important;
      --zen-themed-toolbar-bg: var(--clr-menu) !important;

      /* Background color for main frame */
      --zen-main-browser-background: var(--clr-menu) !important;
      --toolbox-bgcolor-inactive: var(--clr-menu) !important;

      /* Remove rounding*/
      --zen-button-border-radius: 0px !important;
      --toolbarbutton-border-radius: 0px !important;
      --fp-contextmenu-menuitem-border-radius: 0px !important;
      --fp-contextmenu-border-radius: 0px !important;
      --zen-border-radius: 0px !important;
      --zen-webview-border-radius 0px !important;
      --zen-native-inner-radius: 0px !important;

      font-family: var(--font-base) !important;
      border-radius: 0px !important;
    }

    .dialogBox {

      border-radius: 0px !important;
    }
    #urlbar-background {
      background-color: var(--clr-menu) !important;
      border: 1px var(--clr-fg) solid !important;
      border-radius: 0px !important;
    }

    .urlbarView-row {
      background-color: var(--clr-menu) !important;
      border-radius: 0px !important;
      color: var(--clr-fg) !important;
      border: var(--border-inactive) !important;
      font-family: var(--font-base) !important;
      margin: 10px !important;
    }
    .urlbarView-row[selected] {
      background-color: var(--clr-bg) !important;
      border: var(--border-active) !important;
    }

    .urlbarView-row:hover:not([selected]) {
      background-color: var(--clr-bg) !important;
      border: var(--border-active) !important;
    }

    .urlbar-input {
      color: var(--clr-fg) !important;
    }
    #urlbar-container {
      color: var(--clr-fg) !important;
      border-radius: 0 !important;
      background-color: transparent !important;
    }

    .identity-box-button {
      color: var(--clr-inactive) !important;
    }

    .tab-background {
      border-radius: 0 !important;
      background-color: var(--clr-menu) !important;
      border: var(--border-inactive) !important;
    }

    .tab-background[selected] {
      border-radius: 0 !important;
      background-color: var(--clr-bg) !important;
      border: var(--border-active) !important;
    }
    .zen-current-workspace-indicator {
      color: var(--clr-fg) !important;
      text-align: center !important;

      border-radius: 0 !important;
    }
    .zen-current-workspace-indicator {
      border: var(--border-active) !important;
      background-color: var(--clr-menu) !important;
    }

    tab-group {
      border-radius: 0 !important;
      border: var(--border-inactive) !important;
      background-color: var(--clr-menu)!important;
    }


    .zen-current-workspace-indicator::before {
      border-radius: 0px !important;
      background-color: var(--clr-menu) !important;
    }


    .zen-current-workspace-indicator {
      color: var(--clr-fg) !important;
      border-radius: 0 !important;
      border: var(--border-active) !important;
      background-color: var(--clr-menu) !important;
    }


    .zen-current-workspace-indicator-name {
      border-radius: 0px !important;
      width: 100% !important;
      font-size: 1.3rem !important;
    }

    button {
      border-radius: 0px !important;
      font-family: var(--font-base) !important;
    }
  }

''
