{
  vim = {
    languages.markdown = {
      enable = true;
      vale.enable = true;
      ltex.enable = true;
      extensions = {
        render-markdown-nvim = {
          enable = true;
          setupOpts = {
            heading = {
              border = true;
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
