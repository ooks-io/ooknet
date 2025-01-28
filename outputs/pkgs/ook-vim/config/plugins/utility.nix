{
  vim = {
    binds.whichKey = {
      enable = true;
    };
    utility = {
      preview = {
        markdownPreview = {
          enable = true;
          autoStart = false;
        };
      };
      images.image-nvim = {
        enable = true;
        setupOpts = {
          backend = "kitty";
        };
      };
    };
  };
}
