{hozen}: let
  inherit (hozen) color;
in
  /*
  css
  */
  ''

    @define-color accent_color #${color.primary.base};
    @define-color accent_bg_color #${color.primary.soft1};
    @define-color accent_fg_color #${color.layout.menu};

    @define-color destructive_color #${color.blue.base};
    @define-color destructive_bg_color #${color.blue.soft2};
    @define-color destructive_fg_color #${color.typography.text};

    @define-color success_color #${color.success.base};
    @define-color success_bg_color #${color.success.bg};
    @define-color success_fg_color #${color.success.fg};

    @define-color warning_color #${color.warning.base};
    @define-color warning_bg_color #${color.warning.bg};
    @define-color warning_fg_color #${color.warning.fg};

    @define-color error_color #${color.error.base};
    @define-color error_bg_color #${color.error.bg};
    @define-color error_fg_color #${color.error.fg};

    @define-color window_bg_color #${color.layout.menu};
    @define-color window_fg_color #${color.typography.text};

    @define-color view_bg_color #${color.layout.body};
    @define-color view_fg_color #${color.typography.text};

    @define-color sidebar_bg_color #${color.layout.menu};
    @define-color sidebar_fg_color #${color.typography.text};
    @define-color sidebar_backdrop_color @window_bg_color;
    @define-color sidebar_shade_color rgba(0, 0, 0, 0.07);
    @define-color secondary_sidebar_bg_color @sidebar_bg_color;
    @define-color secondary_sidebar_fg_color @sidebar_fg_color;
    @define-color secondary_sidebar_backdrop_color @sidebar_backdrop_color;
    @define-color secondary_sidebar_shade_color @sidebar_shade_color;
    @define-color headerbar_bg_color #${color.layout.header};
    @define-color headerbar_fg_color #${color.typography.text};
    @define-color headerbar_border_color #${color.border.base};
    @define-color headerbar_backdrop_color @window_bg_color;
    @define-color headerbar_shade_color rgba(0, 0, 0, 0.36);
    @define-color card_bg_color rgba(255, 255, 255, 0.08);
    @define-color card_fg_color #${color.typography.text};
    @define-color card_shade_color rgba(0, 0, 0, 0.36);
    @define-color dialog_bg_color #${color.layout.body};
    @define-color dialog_fg_color #${color.typography.text};
    @define-color popover_bg_color #${color.layout.menu};
    @define-color popover_fg_color #${color.typography.text};
    @define-color shade_color rgba(0,0,0,0.36);
    @define-color scrollbar_outline_color rgba(0,0,0,0.5);
    @define-color blue_1 #${color.blue.base};
    @define-color blue_2 #${color.blue.base};
    @define-color blue_3 #${color.blue.base};
    @define-color blue_4 #${color.blue.base};
    @define-color blue_5 #${color.blue.base};
    @define-color green_1 #${color.green.base};
    @define-color green_2 #${color.green.base};
    @define-color green_3 #${color.green.base};
    @define-color green_4 #${color.green.base};
    @define-color green_5 #${color.green.base};
    @define-color yellow_1 #${color.yellow.base};
    @define-color yellow_2 #${color.yellow.base};
    @define-color yellow_3 #${color.yellow.base};
    @define-color yellow_4 #${color.yellow.base};
    @define-color yellow_5 #${color.yellow.base};
    @define-color orange_1 #${color.orange.base};
    @define-color orange_2 #${color.orange.base};
    @define-color orange_3 #${color.orange.base};
    @define-color orange_4 #${color.orange.base};
    @define-color orange_5 #${color.orange.base};
    @define-color red_1 #${color.red.base};
    @define-color red_2 #${color.red.base};
    @define-color red_3 #${color.red.base};
    @define-color red_4 #${color.red.base};
    @define-color red_5 #${color.red.base};
    @define-color purple_1 #${color.purple.base};
    @define-color purple_2 #${color.purple.base};
    @define-color purple_3 #${color.purple.base};
    @define-color purple_4 #${color.purple.base};
    @define-color purple_5 #${color.purple.base};
    @define-color brown_1 #${color.brown.base};
    @define-color brown_2 #${color.brown.base};
    @define-color brown_3 #${color.brown.base};
    @define-color brown_4 #${color.brown.base};
    @define-color brown_5 #${color.brown.base};
    @define-color light_1 #${color.neutrals."250"};
    @define-color light_2 #${color.neutrals."200"};
    @define-color light_3 #${color.neutrals."150"};
    @define-color light_4 #${color.neutrals."100"};
    @define-color light_5 #${color.neutrals."50"};
    @define-color dark_1 #${color.neutrals."700"};
    @define-color dark_2 #${color.neutrals."750"};
    @define-color dark_3 #${color.neutrals."800"};
    @define-color dark_4 #${color.neutrals."850"};
    @define-color dark_5 #${color.neutrals."900"};

    * {
      border-radius: 0;
    }
  ''
