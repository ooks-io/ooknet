{
  system.switch.enable = false;
  ooknet.host = {
    role = "installer";
    admin = {
      name = "ooks";
      shell = "bash";
    };
  };

  isoImage = {
    makeEfiBootable = true;
    makeUsbBootable = true;
    edition = "ooknet";
  };

  system.stateVersion = "25.05";
}
