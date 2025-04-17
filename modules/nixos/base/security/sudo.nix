{
  security.sudo = {
    # allow wheel user to execute sudo without a password
    wheelNeedsPassword = false;
    # only allow users in the wheel access to sudo
    execWheelOnly = true;
  };
}
