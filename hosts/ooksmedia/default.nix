{ lib, pkgs, ... }:

let
	key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBn3ff3HaZHIyH4K13k8Mwqu/o7jIABJ8rANK+r2PfJk";
in

{
	imports = [
		./hardware-configuration.nix
	];

	ooknet.host = {
		name = "ooksmedia";
		type = "desktop";
		function = [
			"workstation"
			"gaming"
			"media-server"
		];
		admin = {
			name = "ooks";
			shell = "fish";
			sshKey = key;
			homeManager = true;
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
		};
	};
  	
	ooknet.networking.tailscale = {
		enable = true;
		server = true;
	};

  boot = {
	  kernelPackages = pkgs.linuxPackages_xanmod_latest;
	};

  system.stateVersion = lib.mkDefault "23.11";
}
