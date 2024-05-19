{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    traceroute
    mtr
    tcpdump
  ];
}
