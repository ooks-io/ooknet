{ lib, pkgs, ... }:

let
	key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBn3ff3HaZHIyH4K13k8Mwqu/o7jIABJ8rANK+r2PfJk";
in

{
	imports = [
		./hardware-configuration.nix
	];

	ooknet.host = {
		name = "ooksdesk";
		type = "desktop";
		role = "workstation";
		profiles = [ "gaming" "creative" "media" "console-tools" ];
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
			cpu.type = "amd";
			cpu.amd.pstate.enable = true;
			gpu.type = "amd";
			features = [ "ssd" "audio" "video" ];
			monitors = [{
				name = "DP-1";
				primary = true;
				width = 2560;
				height = 1440;
				refreshRate = 155;
				workspace = "1";
			}];
		};
	};

  boot = {
	  kernelPackages = pkgs.linuxPackages_xanmod_latest;
	};

  system.stateVersion = lib.mkDefault "23.11";
}
