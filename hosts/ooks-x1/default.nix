{ pkgs, lib, ... }:

let
	inherit (lib) mkDefault;
	key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBn3ff3HaZHIyH4K13k8Mwqu/o7jIABJ8rANK+r2PfJk";
in

{
	imports = [
		./hardware-configuration.nix
	];


	ooknet.host = {
		name = "ooksx1";
		type = "laptop";
		role = "workstation";
		profiles = [ "console-tools" ];
		admin = {
			name = "ooks";
			shell = "fish";
			sshKey = key;
			homeManager = true;
		};
		hardware = {
			cpu.type = "intel";
			gpu.type = "intel";
			features = [
				"bluetooth"
				"backlight"
				"battery"
				"ssd"
				"audio"
				"video"
			];
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

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  };

	system.stateVersion = mkDefault "23.11";
}
