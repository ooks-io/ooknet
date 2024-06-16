{ lib, pkgs, ... }:

let
	key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBn3ff3HaZHIyH4K13k8Mwqu/o7jIABJ8rANK+r2PfJk";
in

{
	imports = [
		./hardware-configuration.nix
		./modules
	];

	ooknet.host = {
		name = "ooksmedia";
		type = "desktop";
		role = "workstation";
		profiles = [ "media-server" "console-tools" ];
		admin = {
			name = "ooks";
			shell = "fish";
			sshKey = key;
			homeManager = true;
		};
		networking = {
			tailscale = {
				enable = true;
				server = true;
				autoconnect = true;
			};
		};
		hardware = {
			cpu.type = "intel";
			cpu.amd.pstate.enable = true;
			gpu.type = "nvidia";
			features = [
				"audio"
				"video"
				"ssd"
			];
		  monitors = [{
		    name = "HDMI-A-1";
		    width = 1920;
		    height = 1080;
		    refreshRate = 60;
		    workspace = "1";
		    primary = true;
		  }];
		};
	};
  boot = {
	  kernelPackages = pkgs.linuxPackages_xanmod_latest;
	};

  system.stateVersion = lib.mkDefault "23.11";
}
