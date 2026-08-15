{
  imports = [
    ./qemu.nix
    ./disko.nix
    ./hardware.nix
  ];

  # throwaway test vm, no state to preserve
  system.stateVersion = "26.11";
}
