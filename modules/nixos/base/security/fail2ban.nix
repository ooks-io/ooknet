{pkgs, ...}: {
  services.fail2ban = {
    enable = true;
    ignoreIP = [
      "127.0.0.0/8"
      "100.64.0.0/10"
      "192.168.0.0/16"
    ];
    extraPackages = [
      pkgs.ipset
      pkgs.nftables
    ];

    bantime = "20m";
    bantime-increment = {
      enable = true;
      multipliers = "4 8 16 32 128 256 512 2048 4116 8236 32944";
      maxtime = "8760h"; # 1 year
      overalljails = true;
    };
    maxretry = 3;
  };
}
