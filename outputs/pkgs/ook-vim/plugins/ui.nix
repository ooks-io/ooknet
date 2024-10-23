{
  vim = {
    ui = {
      borders = {
        enable = true;
        globalStyle = "single";
      };

      # better cmd line
      noice.enable = true;

      colorizer.enable = true;
      illuminate.enable = true;
    };
    # < https://github.com/NotAShelf/nvf/tree/main/modules/plugins/visuals >
    visuals = {
      enable = true;

      # icons that other plugins depend on.
      nvimWebDevicons.enable = true;
      fidget-nvim.enable = true;

      # indent lines
      indentBlankline = {
        enable = true;
        setupOpts = {
          scope = {
            enabled = false;
            injected_languages = false;
          };
        };
      };
    };
  };
}
