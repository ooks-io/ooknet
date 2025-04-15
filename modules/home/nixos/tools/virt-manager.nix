{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) elem mkIf;
  inherit (osConfig.ooknet.workstation) profiles;
in {
  config = mkIf (elem "virtualization" profiles) {
    # setup connections for virt-manager
    # see <https://nixos.wiki/wiki/Virt-manager>
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };
}
