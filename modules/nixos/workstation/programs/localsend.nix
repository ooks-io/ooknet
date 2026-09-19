{
  programs.localsend = {
    # opens tcp+udp 53317. without it the input chain drops incoming
    # transfers, so you can send but never receive
    openFirewall = true;
    enable = true;
  };
}
