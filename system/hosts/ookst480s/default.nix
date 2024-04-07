{ config, inputs, pkgs, ... }:

{
	imports = [
    inputs.hardware.nixosModules.lenovo-thinkpad-t480s
		./hardware-configuration.nix
    ../../profiles
		];

    activeProfiles = ["base" "laptop"];

		systemModules.user = {
			ooks.enable = true;
			shell.fish.enable = true;
		};

		systemModules.laptop.power = {
			powersave = {
				minFreq = 800;
				maxFreq = 1800;
			};
			performance = {
				minFreq = 1800;
				maxFreq = 3600;
			};
		};

		networking = {
  		hostName = "ookst480s"; 		
		};
    boot = {
      kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    };
}
