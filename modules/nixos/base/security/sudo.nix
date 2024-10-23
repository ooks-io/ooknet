{
  security = {
    sudo = {
      # allow wheel user to execute sudo without a password
      wheelNeedsPassword = false;
      # only allow users in the wheel access to sudo
      execWheelOnly = true;
      extraConfig = ''
        Defaults pwfeedback # password feedback
        Defaults lecture = never # disable warning message
        Defaults timestamp_timeout=10 # set sudo timeout to 10 minutes
      '';
    };
  };
}
