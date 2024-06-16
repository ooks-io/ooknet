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
		name = "ookst480s";
		type = "laptop";
		role = "workstation";
		profiles = [ "console-tools" "media" ];
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
				autoconnect = true;
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
			monitors = [{
		    name = "eDP-1";
		    width = 1920;
		    height = 1080;
		    workspace = "1";
		    primary = true;
			}];
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
