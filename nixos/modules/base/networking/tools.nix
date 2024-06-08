{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    traceroute
    mtr
    tcpdump
  ];

  programs = {
    wireshark.enable = true;
    bandwhich.enable = true;
  };
}
