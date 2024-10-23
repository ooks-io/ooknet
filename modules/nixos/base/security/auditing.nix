{pkgs, ...}: {
  security = {
    audit = {
      enable = true;
      rules = ["-a exit, always -F arch=b64 -s execve"];
    };
  };
  environment.systemPackages = [pkgs.lynis];
}
