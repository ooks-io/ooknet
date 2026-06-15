{
  imports = [
    ./image.nix
    ./base
  ];

  ooknet.server.forgejo = {
    customTheme.enable = true;
    hideLogo = true;
  };

  system.stateVersion = "24.11";
}
