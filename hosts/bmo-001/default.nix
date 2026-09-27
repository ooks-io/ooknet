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
        # freenove 5" dsi (FNK0078A) on CAM/DISP 1, behaves like the official 7"
        # display (tc358762, attiny backlight at 0x45, ft5x06 touch at 0x38).
        # explicit instead of relying on display_auto_detect. dsi1 default.
        # dark screen + -121 i2c errors = ribbon in the wrong way round
        dtoverlay=vc4-kms-dsi-7inch
      '';
    };
  };

  system.stateVersion = "26.05";
}
