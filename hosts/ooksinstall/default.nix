{
  ooknet = {
    host = {
      admin = {
        name = "ooks";
        shell = "bash";
      };
    };
  };

  services.getty = {
    autologinUser = "ooks";
    helpLine = ''
      Welcome to the ooknet installer

      To get started, authenticate with tailscale.

      For access to a graphical environment use the command Hyprland
    '';
  };

  system.stateVersion = "25.05";
}
