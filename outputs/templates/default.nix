{
  flake.templates = {
    default = {
      path = ./basic;
      description = "Default project template";
    };
    go = {
      path = ./go;
      description = "Basic go template";
    };
  };
}
