let
  users = {
    ooks = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEx2kNirkcFrNji+qz7KX+zdRxpgJyOwK0vyBrx9Ae3c";
  };

  hosts = {
    ooksdesk = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBn3ff3HaZHIyH4K13k8Mwqu/o7jIABJ8rANK+r2PfJk";
    ooksmedia = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL7ttz1jTy+byfzi874vogy3ZPLW9+8W2o512tdsqUUV";
    ookst480s = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEWFZwTuHIITHa7s4Zp6KPF2suZIMXZbe085OiG0GRh5";
    ooksphone = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINredx07UAk2l1wUPujYnmJci1+XEmcUuSX0DIYg6Vzz";
    ooksmicro = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMUSu2iy3GvMXT5eEDAymIwSQe8UuVG5GH5FJ408JiG4";
    ooksx1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBR6Cyx64Qjth/4aS2x95scEkfiOnsCzufMZW5e41bfE";
  };

  workstations = [
    hosts.ooksdesk
    hosts.ooksmedia
    hosts.ookst480s
    hosts.ooksphone
    hosts.ooksmicro
    hosts.ooksx1
  ];
in

{
  inherit users hosts workstations;
}
