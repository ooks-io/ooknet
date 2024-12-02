{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (config.ooknet.workstation) profiles;
  winlabNetwork = pkgs.writeText "winlab-network.xml" ''
    <network>
      <name>winlab-network</name>
      <uuid>fed01297-b97b-49b0-beeb-8f30bc472017</uuid>
      <forward mode="nat"/>
      <bridge name="virbr1" stp="on" delay="0"/>
      <mac address="52:54:00:fb:72:a8"/>
      <domain name="winlab-network"/>
      <ip address="192.168.100.1" netmask="255.255.255.0">
        <dhcp>
          <range start="192.168.100.100" end="192.168.100.254"/>
        </dhcp>
      </ip>
    </network>
  '';
in {
  config = mkIf (elem "virtualization" profiles) {
    systemd.tmpfiles.settings.qemuNetworks."/var/lib/libvirt/qemu/networks/winlab-network.xml"."f" = {
      argument = winlabNetwork;
    };
  };
}
