{lib, ...}: let
  inherit (lib) mkForce;
in {
  networking = {
    tempAddresses = "disabled";
    usePredictableInterfaceNames = mkForce false;
    interfaces.eth0 = {
      tempAddress = "disabled";
      useDHCP = true;
    };
    firewall.allowedUDPPorts = [443];
  };
}
