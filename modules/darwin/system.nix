{
  system = {
    keyboard = {
      enableKeyMapping = true;
    };
    defaults = {
      finder = {
        # always show file extensions
        AppleShowAllExtensions = true;
        CreateDesktop = false;
        # set default search scope to current folder
        FXDefaultSearchScope = "SCcf";
        # disable warning when changing file extension
        FXEnableExtensionChangeWarning = false;
      };
      dock = {
        autohide = true;
        show-recents = false;
        # only show opened apps
        static-only = true;
      };
    };
  };
}
