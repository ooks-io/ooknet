{self, ...}: {
  imports = [
    "${self}/modules/nixos/hardware/rpi5.nix"
    ./disko.nix
    ./hardware.nix
  ];

  ooknet = {
    hardware = {
      features = ["ssd" "wifi"];
      # waveshare m.2 hat has no HAT+ eeprom, waveshare says to enable the port
      # explicitly instead of relying on the bootloader turning it on
      rpi5.configTxt = ''
        dtparam=pciex1
      '';
    };
  };

  system.stateVersion = "26.05";
}
