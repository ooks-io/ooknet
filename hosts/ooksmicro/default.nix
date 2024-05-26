{  pkgs, ... }:

{
	imports = [
		./hardware-configuration.nix
    ../../profiles
		];

    activeProfiles = ["base" "laptop"];

		ooknet.user = {
			ooks.enable = true;
			shell.fish.enable = true;
		};

		ooknet.laptop.power = {
			powersave = {
				minFreq = 800;
				maxFreq = 1600;
			};
			performance = {
				minFreq = 1100;
				maxFreq = 2600;
			};
		};
  	
		networking = {
  		hostName = "ooksmicro";
		};
		
    boot = {
      kernelPackages = pkgs.linuxKernel.packages.linux_zen;
			# need this due to 
	    kernelParams = [ "fbcon=rotate:1" ];
			# required for keyboard to work during boot
			initrd.availableKernelModules = [ "battery" ];
    };
}
