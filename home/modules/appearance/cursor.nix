{osConfig, ...}: {
  home.pointerCursor = {
    inherit (osConfig.ooknet.appearance.cursor) package name size;
    gtk.enable = true;
    x11.enable = true;
  };
}
