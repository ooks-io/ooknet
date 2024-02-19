{ config, inputs, pkgs, ... }:

{
	imports = [
		./hardware-configuration.nix
    ../../profiles
		];

    activeProfiles = ["base" "nvidia" "mediaServer" "gaming"];

		systemModules.user = {
			ooks.enable = true;
			shell.fish.enable = true;
		};
  	
		networking = {
  		hostName = "ooksdesk"; 		
			# useDHCP = true;
		};
    boot = {
      kernelPackages = pkgs.linuxPackages_xanmod_latest;
		};
}
