{pkgs, ...}: {
  programs.zsh.plugins = [
    {
      name = "fast-syntax-highlighting";
      file = "fast-syntax-highlighting";
      src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
    }
    {
      name = "zsh-autopair";
      file = "autopair.zsh";
      src = "${pkgs.zsh-autopair}/share/zsh/zsh-autopair";
    }
  ];
}
