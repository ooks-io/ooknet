{
  vim = {
    languages.markdown = {
      enable = true;
      vale.enable = false;
      ltex.enable = true;
      extensions = {
        render-markdown-nvim = {
          enable = true;
          setupOpts = {
            heading = {
              width = "block";
              left_pad = 3;
              right_pad = 4;
            };
          };
        };
      };
    };
  };
}
