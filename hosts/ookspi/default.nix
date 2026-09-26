# generic pi5 installer, flash to sd then `ooknet-provision <host> ookspi.local`
{self, ...}: {
  imports = ["${self}/modules/nixos/hardware/rpi5.nix"];

  ooknet.host.admin = {
    name = "ooks";
    shell = "bash";
  };

  system.stateVersion = "26.05";
}
