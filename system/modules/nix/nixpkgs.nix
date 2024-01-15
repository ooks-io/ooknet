{ outputs, ... }: {

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "openssl-1.1.1u"
        "electron-25.9.0"
      ];
    };
  };
}
