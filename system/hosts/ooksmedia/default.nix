{ config, inputs, pkgs, ... }:

{
	imports = [
		./hardware-configuration.nix
    ../../profiles
		];

    activeProfiles = ["base" "mediaServer" "gaming"];

		systemModules.user = {
			ooks.enable = true;
			shell.fish.enable = true;
		};

		systemModules.hardware = {
			cpu.type = "intel";
			gpu.type = "nvidia";
		};
  	
		networking = {
  		hostName = "ooksmedia"; 		
			# useDHCP = true;
		};
    boot = {
      kernelPackages = pkgs.linuxPackages_xanmod_latest;
		};
}
