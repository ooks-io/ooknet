{
  services = {
    openssh = {
      enable = true;
      startWhenNeeded = true;
      ports = [22];
      settings = {
        UseDns = true;
        PubkeyAuthentication = "yes";
        PermitRootLogin = "no";
        PermitEmptyPasswords = "no";
        PasswordAuthentication = false;

        # disable support for .rhost files
        IgnoreRhosts = "yes";

        # by default openssh uses port 22

        # restict key exchange, cipher, and MAC algorithms, as per <https://www.ssh-audit.com>
        KexAlgorithms = [
          "sntrup761x25519-sha512@openssh.com"
          "curve25519-sha256"
          "curve25519-sha256@libssh.org"
          "diffie-hellman-group18-sha512"
          "diffie-hellman-group-exchange-sha256"
          "diffie-hellman-group16-sha512"
          "ecdh-sha2-nistp256"
        ];
        Ciphers = [
          "chacha20-poly1305@openssh.com"
          "aes128-ctr"
          "aes192-ctr"
          "aes256-ctr"
          "aes256-gcm@openssh.com"
          "aes128-gcm@openssh.com"
        ];
        Macs = [
          "hmac-sha2-512-etm@openssh.com"
          "hmac-sha2-256-etm@openssh.com"
          "umac-128-etm@openssh.com"
        ];
      };
    };
    fail2ban.jails.sshd.settings = {
      enable = true;
      filter = "sshd";
      mode = "aggressive";
    };
  };
}
