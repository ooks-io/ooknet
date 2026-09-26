{
  flake.ooknet.images = {
    ooksinstall = {
      system = "x86_64-linux";
      type = "iso";
      role = "installer";
    };
    ookspi = {
      system = "aarch64-linux";
      type = "sd";
      role = "installer";
    };
  };
}
