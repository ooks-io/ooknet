{pkgs, ...}: {
  programs.fish = {
    plugins = [
      {
        name = "done";
        inherit (pkgs.fishPlugins.done) src;
      }
      {
        name = "autopair";
        inherit (pkgs.fishPlugins.autopair) src;
      }
      {
        name = "colored-man-pages";
        inherit (pkgs.fishPlugins.colored-man-pages) src;
      }
    ];
  };
}
