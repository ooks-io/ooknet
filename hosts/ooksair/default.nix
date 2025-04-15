{
  ooknet = {
    host = {
      admin = {
        name = "ooks";
        shell = "fish";
        homeManager = true;
      };
    };
    workstation = {
      theme = "minimal";
      default = {
        browser = "firefox";
        terminal = "ghostty";
      };
    };
    console = {
      profile = "standard";
      editor = "nvim";
      multiplexer = "zellij";
    };
  };
}
