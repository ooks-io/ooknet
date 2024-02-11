{ config, inputs, pkgs, ... }:

{
	imports = [
		./hardware-configuration.nix
    ../../profiles
		];

    activeProfiles = ["base"];

		systemModules.user = {
			ooks.enable = true;
			shell.fish.enable = true;
		};
  	
		networking = {
  		hostName = "ooksdesk"; 		
		};
    boot = {
      kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    };
}
