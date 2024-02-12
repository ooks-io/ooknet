{ config, inputs, pkgs, ... }:

{
	imports = [
		./hardware-configuration.nix
    ../../profiles
		];

    activeProfiles = ["base" "nvidia"];

		systemModules.user = {
			ooks.enable = true;
			shell.fish.enable = true;
		};
  	
		networking = {
  		hostName = "ooksdesk"; 		
			useDHCP = true;
		};
    boot = {
      kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    };
}
