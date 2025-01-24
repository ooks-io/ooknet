{hozen, ...}: let
  inherit (hozen) color;
in {
  vim.gruvbox-material = {
    enable = true;
    contrast = "medium";
    italics = false;
    transparent = false;
    additionalHighlights = {
      RenderMarkdownH1Bg = {bg = "#${color.layout.body}";};
      RenderMarkdownH2Bg = {bg = "#${color.layout.body}";};
      RenderMarkdownH3Bg = {bg = "#${color.layout.body}";};
      RenderMarkdownH4Bg = {bg = "#${color.layout.body}";};
      RenderMarkdownH5Bg = {bg = "#${color.layout.body}";};
      RenderMarkdownH6Bg = {bg = "#${color.layout.body}";};
      "@markup.heading.1" = {
        fg = "#${color.green.base}";
        bold = true;
      };
      "@markup.heading.2" = {
        fg = "#${color.blue.base}";
        bold = true;
      };

      NoiceCmdlinePopupBorder = {fg = "#${color.border.active}";};
      NoiceCmdlinePopupBorderHelp = {fg = "#${color.yellow.base}";};
      NoiceCmdlineIcon = {fg = "#${color.green.base}";};
      NoiceCmdLinePopupTitle = {fg = "#${color.typography.text}";};
    };
  };
}
