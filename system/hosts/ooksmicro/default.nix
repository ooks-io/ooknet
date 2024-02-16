{ config, inputs, pkgs, ... }:

{
	imports = [
    inputs.hardware.nixosModules.gpd-micropc
		./hardware-configuration.nix
    ../../profiles
		];

    activeProfiles = ["base" "laptop"];

		systemModules.user = {
			ooks.enable = true;
			shell.fish.enable = true;
		};
  	
		networking = {
  		hostName = "ooksmicro";
		};
		
    boot = {
      kernelPackages = pkgs.linuxKernel.packages.linux_zen;
	    kernelParams = [ "fbcon=rotate:1" ];

    };
}
