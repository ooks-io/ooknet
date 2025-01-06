{
  vim = {
    languages.markdown = {
      enable = true;
      format = true;
      extensions = {
        render-markdown-nvim = {
          enable = true;
        };
      };
    };
    utility = {
      preview.markdownPreview = {enable = false;};
    };
  };
}
