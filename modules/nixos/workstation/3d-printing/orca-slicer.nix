{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (config.ooknet.workstation) profiles;
in {
  config = mkIf (elem "3dprinting" profiles) {
    # nixpkgs orca links gcc-15 libstdc++, bambus proprietary network plugin
    # wants an older one. loading it corrupts the heap and orca aborts with
    # "free(): invalid size" before the window opens. fhs wrappers dont help,
    # orcas rpath still points at the nix store gcc. the flatpak is built
    # against the freedesktop runtime so the plugin abi lines up
    services.flatpak = {
      enable = true;
      # origin defaults to flathub
      packages = ["com.orcaslicer.OrcaSlicer"];
    };
  };
}
