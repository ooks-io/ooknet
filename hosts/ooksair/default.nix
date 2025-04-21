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
      environment = "aerospace";
      profiles = ["communication"];
      default = {
        browser = "zen";
        terminal = "ghostty";
      };
    };
    console = {
      profile = "standard";
      editor = "nvim";
      multiplexer = "zellij";
    };
  };
  system.stateVersion = 6;
}
