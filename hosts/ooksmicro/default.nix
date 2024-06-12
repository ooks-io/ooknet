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
		name = "ooksmicro";
		type = "micro";
		role = "workstation";
		profiles = [ "console-tools" ];
		admin = {
			name = "ooks";
			shell = "fish";
			sshKey = key;
			homeManager = true;
		};
		networking = {
			tailscale = {
				enable = true;
				client = true;
			};
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
					minFreq = 500;
					maxFreq = 800;
				};
				performance = {
					minFreq = 1200;
					maxFreq = 2400;
				};
			};
		};
	  monitors = [{
	    name = "DSI-1";
	    width = 720;
	    height = 1280;
	    workspace = "1";
	    primary = true;
	    transform = 3;
	  }];
	};

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  };

	system.stateVersion = mkDefault "23.11";
}
