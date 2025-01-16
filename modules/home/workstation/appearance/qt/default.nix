{
  pkgs,
  hozen,
  lib,
  ...
}: let
  inherit (hozen) color;
  mkKvconig = text: lib.generators.toINI {} text;
  kvantumSVG = import ./gruv.nix {inherit color;};

  theme = "KvHozen";
in {
  imports = [
    ./kdeglobals.nix
  ];

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style = {
      name = "kvantum";
    };
  };

  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = mkKvconig {
      General = {inherit theme;};
      #Applications."${theme}" = "org.kde.dolphin, dolphin-emu, faster-project-plus";
    };
    "Kvantum/KvHozen/KvHozen.svg".text = kvantumSVG;
    "Kvantum/KvHozen/KvHozen.kvconfig".text = mkKvconig {
      # docs: <https://github.com/tsujan/Kvantum/blob/master/Kvantum/doc/Theme-Config>
      "%General" = {
        author = "ooks";
        comment = "Hozen theme using Hozen color scheme";

        # Window/Widget Behavior
        respect_DE = true;
        x11drag = "menubar_and_primary_toolbar";
        alt_mnemonic = true;
        click_behavior = 0;
        double_click = false;
        inline_spin_indicators = true;
        vertical_spin_indicators = false;
        spin_button_width = 16;
        combo_as_lineedit = true;
        combo_menu = true;
        hide_combo_checkboxes = true;
        combo_focus_rect = true;
        groupbox_top_label = true;
        button_contents_shift = false;
        fill_rubberband = false;
        merge_menubar_with_toolbar = true;
        toolbutton_style = 1;

        # compositing & effects
        composite = true;
        translucent_windows = true;
        reduce_window_opacity = 10;
        reduce_menu_opacity = 0;
        blurring = false;
        popup_blurring = true;
        menu_blur_radius = 5;
        tooltip_blur_radius = 5;
        contrast = 1.00;
        intensity = 1.00;
        saturation = 1.00;

        # animations & visual feedback
        animate_states = false;
        no_inactiveness = false;
        no_window_pattern = false;

        # menu configuration
        menubar_mouse_tracking = true;
        menu_shadow_depth = 7;
        tooltip_shadow_depth = 6;
        spread_menuitems = true;
        submenu_overlap = 0;
        spread_progressbar = true;

        # scrollbars & sliders
        scroll_width = 8;
        scroll_min_extent = 36;
        scrollbar_in_view = false;
        transient_scrollbar = true;
        transient_groove = false;
        slider_width = 4;
        slider_handle_width = 18;
        slider_handle_length = 18;

        # layout & sizing
        layout_spacing = 2;
        layout_margin = 4;
        small_icon_size = 16;
        large_icon_size = 32;
        button_icon_size = 16;
        toolbar_icon_size = 16;

        # widget specific
        check_size = 16;
        tooltip_delay = -1;
        tree_branch_line = true;
        progressbar_thickness = 8;
      };

      # color configuration
      GeneralColors = {
        # Base Colors
        "window.color" = "#${color.layout.menu}";
        "inactive.window.color" = "#${color.layout.menu}";
        "base.color" = "#${color.layout.body}";
        "inactive.base.color" = "#${color.layout.body}";
        "alt.base.color" = "#${color.layout.body}";
        "button.color" = "#${color.layout.menu}";
        "light.color" = "#${color.secondary.base}";
        "mid.light.color" = "#${color.secondary.soft1}";
        "dark.color" = "#${color.secondary.hard1}";
        "mid.color" = "#${color.secondary.base}";

        # Highlight Colors
        "highlight.color" = "#${color.primary.base}";
        "inactive.highlight.color" = "#${color.primary.soft1}";

        # Text Colors
        "text.color" = "#${color.typography.text}";
        "inactive.text.color" = "#${color.typography.subtext}";
        "window.text.color" = "#${color.typography.text}";
        "inactive.window.text.color" = "#${color.typography.subtext}";
        "button.text.color" = "#${color.typography.text}";
        "disabled.text.color" = "#${color.typography.subtext}";
        "tooltip.text.color" = "#${color.typography.text}";
        "highlight.text.color" = "#${color.typography.contrast-text}";
        "link.color" = "#${color.blue.base}";
        "link.visited.color" = "#${color.purple.base}";
        "progress.indicator.text.color" = "#${color.typography.text}";
        "progress.inactive.indicator.text.color" = "#${color.typography.subtext}";
      };

      # Widget-Specific Configurations
      Hacks = {
        transparent_dolphin_view = false;
        blur_konsole = true;
        transparent_ktitle_label = true;
        transparent_menutitle = true;
        respect_darkness = true;
        force_size_grip = false;
        iconless_pushbutton = true;
        iconless_menu = false;
        disabled_icon_opacity = 100;
        normal_default_pushbutton = true;
        tint_on_mouseover = 0;
        blur_translucent = true;
        kinetic_scrolling = false;
        middle_click_scroll = false;
        no_selection_tint = false;
      };

      # Button Configuration
      PanelButtonCommand = {
        frame = true;
        "frame.element" = "button";
        "frame.expanded" = true;
        interior = true;
        "interior.element" = "button";
        "indicator.size" = 8;
        "text.normal.color" = "#${color.typography.text}";
        "text.focus.color" = "#${color.typography.text}";
        "text.press.color" = "#${color.typography.text}";
        "text.toggle.color" = "#${color.typography.text}";
        "text.shadow" = false;
        "text.margin" = 1;
        "text.iconspacing" = 4;
        "frame.expansion" = 6;
      };

      PanelButtonTool = {
        inherits = "PanelButtonCommand";
      };

      # Window Frames
      GenericFrame = {
        inherits = "PanelButtonCommand";
        frame = true;
        "frame.element" = "common";
        interior = false;
        "frame.top" = 3;
        "frame.bottom" = 3;
        "frame.left" = 3;
        "frame.right" = 3;
      };

      # menu configuration
      Menu = {
        inherits = "PanelButtonCommand";
        "frame.element" = "menu";
        "interior.element" = "menu";
        "frame.top" = 3;
        "frame.bottom" = 3;
        "frame.left" = 3;
        "frame.right" = 3;
      };

      MenuItem = {
        inherits = "PanelButtonCommand";
        frame = true;
        interior = true;
        "interior.element" = "menuitem";
        "indicator.size" = 8;
        "text.focus.color" = "#${color.typography.text}";
        "text.press.color" = "#${color.typography.text}";
      };

      MenuBarItem = {
        inherits = "PanelButtonCommand";
        "interior.element" = "menubaritem";
        frame = false;
        "text.margin.top" = 3;
        "text.margin.bottom" = 3;
        "text.margin.left" = 5;
        "text.margin.right" = 5;
      };

      MenuBar = {
        inherits = "PanelButtonCommand";
        "frame.element" = "menubar";
        "interior.element" = "menubar";
        "frame.bottom" = 0;
        "text.normal.color" = "#${color.typography.text}";
      };

      # Scrollbars
      ScrollbarSlider = {
        inherits = "PanelButtonCommand";
        frame = true;
        interior = false;
        "frame.element" = "scrollbarslider";
        "indicator.element" = "grip";
        "indicator.size" = 13;
        "frame.left" = 6;
        "frame.right" = 6;
        "frame.top" = 6;
        "frame.bottom" = 6;
      };

      ScrollbarGroove = {
        inherits = "PanelButtonCommand";
        interior = false;
        frame = false;
      };

      # Sliders
      Slider = {
        inherits = "PanelButtonCommand";
        frame = false;
        "interior.element" = "slider";
        "frame.top" = 3;
        "frame.bottom" = 3;
        "frame.left" = 3;
        "frame.right" = 3;
      };

      SliderCursor = {
        inherits = "PanelButtonCommand";
        frame = false;
        "interior.element" = "slidercursor";
      };

      # Progress Bars
      Progressbar = {
        inherits = "PanelButtonCommand";
        "frame.element" = "progress";
        "interior.element" = "progress";
        "text.margin" = 0;
        "text.normal.color" = "#${color.typography.text}";
        "text.focus.color" = "#${color.typography.text}";
        "text.press.color" = "#${color.typography.contrast-text}";
        "text.toggle.color" = "#${color.typography.contrast-text}";
      };

      ProgressbarContents = {
        inherits = "PanelButtonCommand";
        frame = true;
        "frame.element" = "progress-pattern";
        "interior.element" = "progress-pattern";
      };

      # Tabs
      TabBarFrame = {
        inherits = "GenericFrame";
        frame = true;
        "frame.element" = "tabBarFrame";
        interior = false;
        "frame.top" = 4;
        "frame.bottom" = 4;
        "frame.left" = 4;
        "frame.right" = 4;
      };

      TabFrame = {
        inherits = "PanelButtonCommand";
        "frame.element" = "tabframe";
        "interior.element" = "tabframe";
      };

      Tab = {
        inherits = "PanelButtonCommand";
        "interior.element" = "tab";
        "frame.element" = "tab";
        "frame.top" = 2;
        "frame.bottom" = 2;
        "frame.left" = 2;
        "frame.right" = 2;
        "text.margin.left" = 8;
        "text.margin.right" = 8;
        "text.margin.top" = 2;
        "text.margin.bottom" = 2;
      };

      # Line Edits
      LineEdit = {
        inherits = "PanelButtonCommand";
        "frame.element" = "lineedit";
        "interior.element" = "lineedit";
        "frame.top" = 3;
        "frame.bottom" = 3;
        "frame.left" = 3;
        "frame.right" = 3;
        "text.margin.top" = 2;
        "text.margin.bottom" = 2;
        "text.margin.left" = 2;
        "text.margin.right" = 2;
      };

      # Combo Boxes
      ComboBox = {
        inherits = "PanelButtonCommand";
        "frame.element" = "combo";
        "interior.element" = "combo";
        "frame.top" = 3;
        "frame.bottom" = 3;
        "frame.left" = 3;
        "frame.right" = 3;
        "text.margin.top" = 2;
        "text.margin.bottom" = 2;
        "text.margin.left" = 2;
        "text.margin.right" = 2;
        "indicator.element" = "carrow";
      };

      # Spinboxes
      SpinBox = {
        inherits = "ComboBox";
        "frame.element" = "spinbox";
        "interior.element" = "spinbox";
        "frame.top" = 3;
        "frame.bottom" = 3;
        "frame.left" = 3;
        "frame.right" = 3;
        "indicator.element" = "arrow";
        "indicator.size" = 8;
      };

      # Group Boxes
      GroupBox = {
        inherits = "GenericFrame";
        frame = true;
        "frame.element" = "group";
        interior = false;
        "frame.top" = 4;
        "frame.bottom" = 4;
        "frame.left" = 4;
        "frame.right" = 4;
      };

      # tooltips
      ToolTip = {
        inherits = "PanelButtonCommand";
        "frame.top" = 3;
        "frame.bottom" = 3;
        "frame.left" = 3;
        "frame.right" = 3;
        interior = true;
        "text.shadow" = false;
        "text.margin" = 0;
        "frame.element" = "tooltip";
        "interior.element" = "tooltip";
        "frame.expansion" = 0;
      };

      # window decorations
      Window = {
        interior = true;
        "interior.element" = "window";
        "frame.element" = "window";
        "frame.top" = 0;
        "frame.bottom" = 0;
        "frame.left" = 0;
        "frame.right" = 0;
      };

      Dialog = {
        inherits = "Window";
      };
    };
  };
  home.packages = with pkgs; [
    libsForQt5.qt5.qtwayland
    kdePackages.qtwayland
    kdePackages.qqc2-desktop-style
    kdePackages.qttools
    qt6Packages.qt6gtk2
    qt6.qtwayland

    libsForQt5.qtstyleplugins
    qt6Packages.qt6gtk2
    libsForQt5.qt5ct
    kdePackages.qt6ct

    #libsForQt5.breeze-qt5
    #kdePackages.breeze-icons
    # kvantum libraries
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
  ];
}
