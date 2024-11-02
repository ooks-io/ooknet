let
  /*
  extended version of gruvbox/gruvbox material to support multiple frameworks:

  - tailwind
  - base16/24
  - semantic

  references:

  shades
  <https://coolors.co/dfd2b3-d9c7a5-d4be98-c6b395-b4a288-a49384-99897a-8b7c6f>
  <https://coolors.co/1a1a1a-212121-282828-343232-3f3b3b-4d4947-585350-645f59-716860-7d6f64>

  colors
  <https://coolors.co/69713f-737c45-7f884c-8c9654-9aa55c-a9b665-b1be74-b8c481-bec98c-c4ce96>
  <https://coolors.co/e57b76-ea6962-e95149-e33e35>
  <https://coolors.co/e69965-e78a4e-e07b38-de732b>
  */
  colors = {
    #shades

    shade-50 = "#dfd2b3";
    shade-100 = "#d9c7a5";
    shade-150 = "#d4be98";
    shade-200 = "#c6b395";
    shade-250 = "#b4a288";
    shade-300 = "#a49384";
    shade-350 = "#99897a";
    shade-400 = "#8b7c6f";
    shade-450 = "#7d6f64";
    shade-500 = "#716860";
    shade-550 = "#645f59";
    shade-600 = "#585350";
    shade-650 = "#4d4947";
    shade-700 = "#3f3b3b";
    shade-750 = "#343232";
    shade-800 = "#282828";
    shade-850 = "#212121";
    shade-900 = "#1a1a1a";

    # we use green as the primary color here.
    primary = "#a9b665";

    # color scale for our primary accent color.
    primary-dark-1 = "#b1be74";
    primary-dark-2 = "${colors.primary-dark-1}";
    primary-dark-3 = "#b8c481";
    primary-dark-4 = "${colors.primary-dark-3}";
    primary-dark-5 = "#bec98c";
    primary-dark-6 = "${colors.primary-dark-4}";
    primary-dark-7 = "#c4ce96";

    primary-light-1 = "#9aa55c";
    primary-light-2 = "${colors.primary-light-1}";
    primary-light-3 = "#8c9654";
    primary-light-4 = "${colors.primary-dark-3}";
    primary-light-5 = "#7f884c";
    primary-light-6 = "${colors.primary-dark-5}";
    primary-light-7 = "#69713f";

    primary-alpha-10 = "${colors.primary}19";
    primary-alpha-20 = "${colors.primary}33";
    primary-alpha-30 = "${colors.primary}4b";
    primary-alpha-40 = "${colors.primary}66";
    primary-alpha-50 = "${colors.primary}80";
    primary-alpha-60 = "${colors.primary}99";
    primary-alpha-70 = "${colors.primary}b3";
    primary-alpha-80 = "${colors.primary}cc";
    primary-alpha-90 = "${colors.primary}e1";

    primary-hover = "${colors.primary-light-2}";
    primary-active = "${colors.primary-light-4}";

    # we use green as the secondary color here.
    secondary = "${colors.shade-700}";

    # color scale for our secondary accent color.
    secondary-dark-1 = "${colors.shade-550}";
    secondary-dark-2 = "${colors.shade-500}";
    secondary-dark-3 = "${colors.shade-450}";
    secondary-dark-4 = "${colors.shade-400}";
    secondary-dark-5 = "${colors.shade-350}";
    secondary-dark-6 = "${colors.shade-300}";
    secondary-dark-7 = "${colors.shade-250}";
    secondary-dark-8 = "${colors.shade-200}";
    secondary-dark-9 = "${colors.shade-150}";
    secondary-dark-10 = "${colors.shade-100}";
    secondary-dark-11 = "${colors.shade-100}";
    secondary-dark-12 = "${colors.shade-100}";
    secondary-dark-13 = "${colors.shade-100}";

    secondary-light-1 = "${colors.shade-650}";
    secondary-light-2 = "${colors.shade-700}";
    secondary-light-3 = "${colors.shade-750}";
    secondary-light-4 = "${colors.shade-800}";

    secondary-alpha-10 = "${colors.secondary}19";
    secondary-alpha-20 = "${colors.secondary}33";
    secondary-alpha-30 = "${colors.secondary}4b";
    secondary-alpha-40 = "${colors.secondary}66";
    secondary-alpha-50 = "${colors.secondary}80";
    secondary-alpha-60 = "${colors.secondary}99";
    secondary-alpha-70 = "${colors.secondary}b3";
    secondary-alpha-80 = "${colors.secondary}cc";
    secondary-alpha-90 = "${colors.secondary}e1";

    secondary-hover = "${colors.secondary-light-1}";
    secondary-active = "${colors.secondary-light-2}";

    red-light = "#e57b76";
    red = "#ea6962";
    red-dark-1 = "#e7534b";
    red-dark-2 = "#e33e35";

    orange-light = "#e69965";
    orange = "#e78a4e";
    orange-dark-1 = "#e07b38";
    orange-dark-2 = "#de732b";

    yellow-light = "#d9b06d";
    yellow = "#d8a657";
    yellow-dark-1 = "#d09a43";
    yellow-dark-2 = "#c99136";

    olive-light = "#beb874";
    olive = "#b9b25f";
    olive-dark-1 = "#ada652";
    olive-dark-2 = "#9b944b";

    green-light = "#b1be74";
    green = "#a9b665";
    green-dark-1 = "#9aa55c";
    green-dark-2 = "#8c9654";

    teal-light = "#9abb95";
    teal = "#89b482";
    teal-dark-1 = "#7aa573";
    teal-dark-2 = "#6c9a65";

    blue-light = "#91b6ae";
    blue = "#7daea3";
    blue-dark-1 = "#6ea096";
    blue-dark-2 = "#63978d";

    violet-light = "#dba3c7";
    violet = "#d892c1";
    violet-dark-1 = "#cd7eb3";
    violet-dark-2 = "#c86faa";

    purple-light = "#d9a0af";
    purple = "#d3869b";
    purple-dark-1 = "#ca778d";
    purple-dark-2 = "#c26680";

    pink-light = "#d8abcc";
    pink = "#cf91be";
    pink-dark-1 = "#c47eb1";
    pink-dark-2 = "#bc71a8";

    brown-light = "#b18568";
    brown = "#a87757";
    brown-dark-1 = "#976b4e";
    brown-dark-2 = "#896248";

    grey-light = "${colors.shade-350}";
    grey = "${colors.shade-450}";
    grey-dark-1 = "${colors.shade-500}";
    grey-dark-2 = "${colors.shade-550}";

    black-light = "${colors.shade-700}";
    black = "${colors.shade-800}";
    black-dark-1 = "${colors.shade-850}";
    black-dark-2 = "${colors.shade-900}";

    # semantic
    body = "${colors.shade-700}";
    header = "${colors.shade-800}";
    text = "${colors.shade-150}";
    text-light = "${colors.shade-100}";
    text-lighter = "${colors.shade-50}";
    texter-dark = "${colors.shade-200}";
    text-darker = "${colors.shade-350}";
    footer = "${colors.shade-800}";
    menu = "${colors.shade-800}";
    border-active = "${colors.shade-150}";
    border-inactive = "${colors.shade-600}";

    error-bg = "${colors.red}";
    error-bg-active = "${colors.red-dark-1}";
    error-bg-hover = "${colors.red-dark-2}";
    error-text = "${colors.shade-800}";
    error-border = "${colors.red-light}";

    success-bg = "${colors.green}";
    success-bg-active = "${colors.green-dark-1}";
    success-bg-hover = "${colors.green-dark-2}";
    success-text = "${colors.shade-800}";
    success-border = "${colors.green-light}";

    warning-bg = "${colors.yellow}";
    warning-bg-active = "${colors.yellow-dark-1}";
    warning-bg-hover = "${colors.yellow-dark-2}";
    warning-text = "${colors.shade-800}";
    warning-border = "${colors.yellow-light}";

    info-bg = "${colors.blue}";
    info-bg-active = "${colors.blue-dark-1}";
    info-bg-hover = "${colors.blue-dark-2}";
    info-text = "${colors.shade-800}";
    info-border = "${colors.blue-light}";

    tip-bg = "${colors.teal}";
    tip-bg-active = "${colors.teal-dark-1}";
    tip-bg-hover = "${colors.teal-dark-2}";
    tip-text = "${colors.shade-800}";
    tip-border = "${colors.teal-light}";

    input-text = "${colors.text-light}";

    # syntax

    syntax = {
      string = "${colors.green}";
      number = "${colors.purple}";
      float = "${colors.purple}";
      boolean = "${colors.purple}";
      type = "${colors.yellow}";
      structure = "${colors.orange}";
      statement = "${colors.red}";
      label = "${colors.orange}";
      operator = "${colors.orange}";
      identifier = "${colors.blue}";
      function = "${colors.green}";
      storageClass = "${colors.orange}";
      constant = "${colors.teal}";
      exception = "${colors.red}";
      preproc = "${colors.purple}";
      include = "${colors.purple}";
      define = "${colors.purple}";
      macro = "${colors.teal}";
      preCondit = "${colors.purple}";
      special = "${colors.yellow}";
      specialChar = "${colors.yellow}";
      comment = "${colors.text-darker}";
      todo = "${colors.purple}";
      tag = "${colors.tag}";

      mdH1 = "${colors.red}";
      mdH2 = "${colors.orange}";
      mdH3 = "${colors.yellow}";
      mdH4 = "${colors.green}";
      mdH5 = "${colors.blue}";
      mdH6 = "${colors.purple}";
    };

    # base 16/24
    base00 = "${colors.shade-800}";
    base01 = "${colors.shade-700}";
    base02 = "${colors.shade-600}";
    base03 = "${colors.shade-450}";
    base04 = "${colors.shade-300}";
    base05 = "${colors.shade-150}";
    base06 = "${colors.shade-100}";
    base07 = "${colors.shade-50}";
    base08 = "${colors.red}";
    base09 = "${colors.orange}";
    base0A = "${colors.yellow}";
    base0B = "${colors.green}";
    base0C = "${colors.teal}";
    base0D = "${colors.blue}";
    base0E = "${colors.purple}";
    base0F = "${colors.brown}";
    base10 = "${colors.shade-850}";
    base11 = "${colors.shade-900}";
    base12 = "${colors.red-light}";
    base13 = "${colors.yellow-light}";
    base14 = "${colors.green-light}";
    base15 = "${colors.teal-light}";
    base16 = "${colors.blue-light}";
    base17 = "${colors.purple-light}";
  };
in {
  inherit colors;
}
