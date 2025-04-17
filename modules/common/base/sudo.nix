{
  security = {
    sudo = {
      extraConfig = ''
        Defaults pwfeedback # password feedback
        Defaults lecture = never # disable warning message
        Defaults timestamp_timeout=10 # set sudo timeout to 10 minutes
      '';
    };
  };
}
