



{ config, inputs, pkgs, ... }:

# Imports
# -------------------------------------------------------------------------------------------------

{
	imports = [
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-intel

		./hardware-configuration.nix
    
    ../common/user/ooks
    ../common/base
    ../common/features/bluetooth.nix
		../common/features/greetd.nix

		];

# Hostname and networking
# -------------------------------------------------------------------------------------------------

	networking = {
		hostName = "ooksx1"; 		
    networkmanager.enable = true;
		};


# Printing
# -------------------------------------------------------------------------------------------------

  services.printing.enable = true;

# Kernel
# ------------------------------------------------------------------------------------------------

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  };


# Laptop Programs
# -------------------------------------------------------------------------------------------------

  powerManagement.powertop.enable = true;
  programs = {
    light.enable = true;
    dconf.enable = true;
    kdeconnect.enable = true;
  };

  
  hardware = {
    opengl = {
      enable = true;
    };
  };

# gnupg
# -------------------------------------------------------------------------------------------------

	programs.gnupg.agent = {
		enable = true;
		enableSSHSupport = true;
 	};

# Services
# -------------------------------------------------------------------------------------------------

	services = {
    logind = {
      lidSwitch = "suspend";
    };
		dbus = {
      enable = true;
      packages = [ pkgs.gcr ];
    };
		auto-cpufreq = {
			enable = true;
			settings = {
				battery = {
					governor = "powersave";
					turbo = "never";
					};
				charger = {
					governor = "performance";
					turbo = "auto";
				};
			};
		};
  };	

	systemd = {
		user.services.polkit-gnome-authentication-agent-1 = {
			description = "polkit-gnome-authentication-agent-1";
			wantedBy = [ "graphical-session.target" ];
			wants = [ "graphical-session.target" ];
			after = [ "graphical-session.target" ];
			serviceConfig = {
				Type = "simple";
				ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
				Restart = "on-failure";
				RestartSec = 1;
				TimeoutStopSec = 10;
			};
		};
	};

# Firewall
# -------------------------------------------------------------------------------------------------

	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	# Or disable the firewall altogether.
	# networking.firewall.enable = false;

# System Version
# -------------------------------------------------------------------------------------------------

	system = {
		stateVersion = "22.05";
	};
}
