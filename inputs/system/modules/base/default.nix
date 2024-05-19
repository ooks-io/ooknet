{ lib, ... }:

{
  imports = [
    ./gaming
    ./shell
    ./bootloader
    ./nix
    ./programs
    ./displayManager
    ./networking
    ./locale
    ./virtualization
    ./security
    ./services
    ./audio
    ./host
    ./video
  ];


  options.systemModules = {
    virtualisation = {
      enable = lib.mkEnableOption "Enable virtualisation module";
    };
  };
}
