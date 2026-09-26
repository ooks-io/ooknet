{self, ...}: {
  imports = [
    "${self}/modules/nixos/hardware/rpi5.nix"
    ./disko.nix
    ./hardware.nix
  ];

  # waveshare m.2 hat has no HAT+ eeprom, waveshare says to enable the port
  # explicitly instead of relying on the bootloader turning it on
  ooknet.hardware.rpi5.configTxt = ''
    dtparam=pciex1
  '';

  system.stateVersion = "26.05";
}
