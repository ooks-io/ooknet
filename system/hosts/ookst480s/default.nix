{ config, inputs, pkgs, ... }:

{
	imports = [
    inputs.hardware.nixosModules.lenovo-thinkpad-t480s
		./hardware-configuration.nix
    ../../profiles
		];

    activeProfiles = ["base"];

		systemModules = {
			user = {
				ooks.enable = true;
				shell.fish.enable = true;
			};
			hardware = {
				cpu.type = "intel";
				gpu.type = "intel";
				features = [ "bluetooth" "backlight" "battery" ];
				battery = {
					powersave = {
						minFreq = 800;
						maxFreq = 1800;
					};
					performance = {
						minFreq = 1800;
						maxFreq = 3600;
					};
				};
			};
		};

		networking = {
  		hostName = "ookst480s"; 		
		};
    boot = {
      kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    };
}
