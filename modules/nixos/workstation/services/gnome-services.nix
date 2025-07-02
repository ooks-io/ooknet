{
  services = {
    # gnome services that I depend on
    gvfs.enable = true;
    gnome = {
      glib-networking.enable = true;
      gnome-keyring.enable = false;
    };
  };
}
