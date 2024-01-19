



{ config, inputs, pkgs, ... }:

# Imports
# -------------------------------------------------------------------------------------------------

{
	imports = [
    inputs.hardware.nixosModules.gpd-micropc

		./hardware-configuration.nix
    
    ../common/user/ooks
    ../common/base
    ../common/features/bluetooth.nix
    ../common/features/vm.nix
    ../common/features/greetd.nix

		];

# Hostname and networking
# -------------------------------------------------------------------------------------------------

	networking = {
		hostName = "ooksmicro"; 		
    networkmanager.enable = true;
		};


# Printing
# -------------------------------------------------------------------------------------------------

  services.printing.enable = true;

# Kernel
# ------------------------------------------------------------------------------------------------

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernelParams = [ "fbcon=rotate:1" ];
  };


# Laptop Programs
# -------------------------------------------------------------------------------------------------

  powerManagement.powertop.enable = true;
  
  programs = {
    light.enable = true;
    dconf.enable = true;
    kdeconnect.enable = true;
  };

# XDG Portal
# ------------------------------------------------------------------------------------------------

  xdg.portal = {
    enable = true;
    wlr.enable = true;
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
    thermald = {
      enable = true;
    };
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


# System Version
# -------------------------------------------------------------------------------------------------

	system = {
		stateVersion = "22.05";
	};
}
