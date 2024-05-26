{ config, inputs, pkgs, ... }:

{
	imports = [ ./hardware-configuration.nix ];

    activeProfiles = ["base" "gaming"];

		systemModules.user = {
			ooks.enable = true;
			shell = "fish";
		};

		systemModules.hardware = {
			cpu.type = "intel";
			gpu.type = "nvidia";
		};

		systemModules.networking.tailscale = {
			enable = true;
			server = true;
		};
  	
		networking = {
  		hostName = "ooksmedia"; 		
		};
    boot = {
      kernelPackages = pkgs.linuxPackages_xanmod_latest;
		};
}
