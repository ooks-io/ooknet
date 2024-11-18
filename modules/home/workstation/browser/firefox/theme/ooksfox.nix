{
  hozen,
  fonts,
  ...
}: let
  inherit (hozen) color;
in
  #css
  ''
    :root {

      --clr-menu: #${color.layout.menu};
      --clr-fg: #${color.typography.text};
      --clr-secondary: #${color.secondary.base};


      --border: 1px solid var(--clr-fg);
      --border-active: 1px solid var(--clr-fg);
      --border-inactive: 1px solid var(--clr-secondary);

      --font-base: ${fonts.monospace.family};

    }

    * {
      border-radius: 0 !important;
      font-family: ${fonts.monospace.family};
    }
    #nav-bar {
      border: var(--border) !important;
      background-color: var(--clr-menu) !important;
      margin-top: 0px !important;
    }
    #urlbar {
      text-align: center;
    }

    .browser-toolbar {
      padding-bottom: 1px !important;
    }

    #urlbar-background {
      background-color: transparent !important;
      border: unset !important;
      box-shadow: unset !important;
    }

    #urlbar-container {
     padding: 0 !important;
    }

    .urlbarView {
      text-align: start;
      border: var(--border) !important;
      margin: 0;
      padding: 0 !important;
      background-color: var(--clr-menu);
    }

    .urlbar-input-container {
      margin: 0px !important;
    }


    #identity-icon {
      color: red !important;
    }

    #forward-button,
    #stop-button,
    #star-button-box,
    #translations-button,
    #reload-button,
    #identity-box,
    #tracking-protection-icon-container,
    #save-to-pocket-button,
    .urlbar-page-action,
    .urlbar-go-button,
    /* firefox account button */
    #fxa-toolbar-menu-button,
    /* hamburger menu icon */
    #PanelUI-button,
    #PersonalToolbar
    {
      display: none;
    }

    .titlebar-buttonbox-container,
    .tab-close-button,
    .titlebar-spacer,
    #tabs-newtab-button,
    #alltabs-button,
    #firefox-view-button,
    #new-tab-button {
      display: none;
    }


    #tabbrowser-tabs {
      margin: 0 !important;
      padding: 0 !important;

      margin-inline: 0px !important;
      border: unset !important;
      border-bottom: var(--border-inactive) !important;
    }

    .tabbrowser-tab {
      padding: 3px !important;
      padding-left: 3px !important;
      --tab-label-mask-size: unset !important;
    }

    .tabbrowser-tab[pinned] {
      padding: 3px !important;
    }

    #tabbrowser-tabs[haspinnedtabs]:not([positionpinnedtabs])[orient="horizontal"] > #tabbrowser-arrowscrollbox > .tabbrowser-tab:nth-child(1 of :not([pinned], [hidden])) {
      margin-inline-start: 0px !important;
    }

    .tab-stack {
      margin-inline: 0 !important;
    }
    .tab-background {
      border-radius: 0px;
      border: var(--border-inactive);
    }
    .tab-background[selected] {
     border: var(--border-active);
    }

    #TabsToolbar {
      padding-left: 0px !important;
      margin: 0;
      padding: 0;
    }

    root{
      --uc-navbar-transform: -40px;
    }
    :root[uidensity="compact"]{ --uc-navbar-transform: -34px }

    #navigator-toolbox > div{ display: contents; }
    :root[sessionrestored] :where(#nav-bar,#PersonalToolbar,#tab-notification-deck,.global-notificationbox){
      transform: translateY(var(--uc-navbar-transform))
    }
    :root:is([customizing],[chromehidden*="toolbar"]) :where(#nav-bar,#PersonalToolbar,#tab-notification-deck,.global-notificationbox){
      transform: none !important;
      opacity: 1 !important;
    }

    #nav-bar:not([customizing]){
      opacity: 0;
      position: relative;
      z-index: 2;
    }
    #titlebar{ position: relative; z-index: 3 }

    #navigator-toolbox,
    #sidebar-box,
    #sidebar-main,
    #sidebar-splitter,
    #tabbrowser-tabbox{
      z-index: auto !important;
    }
    #navigator-toolbox:focus-within > .browser-toolbar{
      transform: translateY(0);
      opacity: 1;
    }
    #titlebar:hover ~ .browser-toolbar,
    .browser-titlebar:hover ~ :is(#nav-bar,#PersonalToolbar),
    #nav-bar:hover,
    #nav-bar:hover + #PersonalToolbar{
      transform: translateY(0);
      opacity: 1;
    }
    :root[sessionrestored] #urlbar[popover]{
      opacity: 0;
      pointer-events: none;
      transform: translateY(var(--uc-navbar-transform));
    }
    #mainPopupSet:has(> [role="group"][panelopen]) ~ toolbox #urlbar[popover],
    .browser-titlebar:is(:hover,:focus-within) ~ #nav-bar #urlbar[popover],
    #nav-bar:is(:hover,:focus-within) #urlbar[popover],
    #urlbar-container > #urlbar[popover]:is([focused],[open]){
      opacity: 1;
      pointer-events: auto;
      transform: translateY(0);
    }
    #mainPopupSet:has(> [role="group"][panelopen]) ~ #navigator-toolbox > .browser-toolbar{
      transform: translateY(0);
      opacity: 1;
    }
    #nav-bar.browser-titlebar{
      background: inherit;
    }
    #toolbar-menubar:not([autohide="true"]) ~ #nav-bar.browser-titlebar{
      background-position-y: -28px; /* best guess, could vary */
      border-top: none !important;
    }
    /* Move up the content view */
    :root[sessionrestored]:not([inFullscreen],[chromehidden~="toolbar"]) > body > #browser{ margin-top: var(--uc-navbar-transform); }
  ''
