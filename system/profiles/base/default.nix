{ inputs, outputs, lib, config, pkgs, ... }:

let
  cfg = config.systemProfile.base;
in

{

  imports = [
    ../../modules
    inputs.home-manager.nixosModules.home-manager
  ];
  
  config = lib.mkIf cfg.enable {
    systemModules = {
      security.enable = true;
      nixOptions.enable = true;
      pipewire.enable = true;
      networking.enable = true;
      locale.enable = true;
      bootloader.systemd.enable = true;
      programs.gnomeServices.enable = true;
      displayManager.tuigreet.enable = true;
      openssh.enable = true;
      hardware.ssd.enable = true;
    };

    environment.systemPackages = [pkgs.git];
    environment.enableAllTerminfo = true;
    
    services = {
      dbus.enable = true; # Need this for gtk
      printing.enable = true; # Do I even print?
      udisks2 = { # Used to manage mount of temp storage
        enable = true;
        mountOnMedia = true; # Auto mounts device to /media
      };
    };

    boot.supportedFilesystems = ["ntfs"]; # For when someone hands me a usb

    programs = {
      dconf.enable = true;
      kdeconnect.enable = true;
    };

    home-manager.extraSpecialArgs = { inherit inputs outputs; };

    hardware = {
      enableAllFirmware = true;
      opengl = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver
          vaapiIntel
          vaapiVdpau
          libvdpau-va-gl
          libva-utils
        ];
        extraPackages32 = with pkgs.pkgsi686Linux; [
          vaapiVdpau
          libvdpau-va-gl
        ];
      };
    };
    system.stateVersion = lib.mkDefault "23.11";
  }; 
}
