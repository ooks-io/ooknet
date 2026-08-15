{
  # run builds at idle cpu/io priority so compiles dont starve the rest of the system
  nix = {
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
  };
}
