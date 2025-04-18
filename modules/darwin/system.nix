{
  system = {
    keyboard = {
      enableKeyMapping = true;
    };
    defaults = {
      trackpad = {
        # tap click
        Clicking = true;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
      };
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
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        AppleKeyboardUIMode = 3;
        AppleShowAllFiles = true;

        NSAutomaticWindowAnimationsEnabled = false;
        NSWindowResizeTime = 0.0;
        NSUseAnimatedFocusRing = false;
        _HIHideMenuBar = true;
      };
    };
    activationScripts = {
      # not sure this is still necessary at this point
      # meant to avoid the need to logout/restart
      # for changes to take effect
      postUserActivation.text = ''
        /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      '';
    };
  };
}
