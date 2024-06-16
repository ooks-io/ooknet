{ lib, pkgs, ... }:

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
