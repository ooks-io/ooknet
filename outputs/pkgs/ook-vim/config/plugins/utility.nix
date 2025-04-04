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
      surround = {
        enable = true;
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
