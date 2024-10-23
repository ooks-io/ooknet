{pkgs, ...}: let
  inherit (builtins) attrValues;
in {
  services.dbus = {
    enable = true;
    packages = attrValues {
      inherit (pkgs) dconf gcr udisks2;
    };
    implementation = "broker";
  };
}
