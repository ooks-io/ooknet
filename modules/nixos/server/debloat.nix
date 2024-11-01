{lib, ...}: let
  inherit (lib) mkDefault;
in {
  # from github:nix-community/srvos

  # disable fonts
  fonts.fontconfig.enable = false;

  # dont generate documentation
  documentation = {
    enable = mkDefault false;
    info.enable = mkDefault false;
    man.enable = mkDefault false;
    nixos.enable = mkDefault false;
  };
}
