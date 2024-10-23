{
  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";

  home = {
    stateVersion = "22.05";
  };
}
