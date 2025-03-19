{
  vim = {
    notify.nvim-notify = {
      enable = true;
    };
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
      # icons that other plugins depend on.
      nvim-web-devicons.enable = true;

      # indent lines
      indent-blankline = {
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
