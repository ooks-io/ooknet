{ config, inputs, pkgs, ... }:

{
	imports = [
		./hardware-configuration.nix
    ../../profiles
		];

    activeProfiles = ["base" "gaming"];

		systemModules.user = {
			ooks.enable = true;
			shell.fish.enable = true;
		};

		systemModules.hardware = {
			cpu.type = "amd";
			gpu.type = "amd";
		};
  	
		networking = {
  		hostName = "ooksdesk"; 		
			# useDHCP = true;
		};
    boot = {
      kernelPackages = pkgs.linuxPackages_xanmod_latest;
		};
}
