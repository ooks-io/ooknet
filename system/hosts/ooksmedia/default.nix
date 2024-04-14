{ config, inputs, pkgs, ... }:

{
	imports = [
		./hardware-configuration.nix
    ../../profiles
		./nixarr.nix
		];

    activeProfiles = ["base" "gaming"];

		systemModules.user = {
			ooks.enable = true;
			shell = "fish";
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
