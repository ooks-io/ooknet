{
  pkgs,
  lib,
  config,
  ...
}: {
  services.aerospace.settings.mode.main.binding = let
    inherit (lib) getExe;
    inherit (config.ooknet.host) admin;
    mod = "cmd";
  in {
    "${mod}-left" = "focus left --boundaries all-monitors-outer-frame";
    "${mod}-right" = "focus right --boundaries all-monitors-outer-frame";
    "${mod}-up" = "focus up --boundaries all-monitors-outer-frame";
    "${mod}-down" = "focus down --boundaries all-monitors-outer-frame";
    "${mod}-h" = "focus left --boundaries all-monitors-outer-frame";
    "${mod}-l" = "focus right --boundaries all-monitors-outer-frame";
    "${mod}-k" = "focus up --boundaries all-monitors-outer-frame";
    "${mod}-j" = "focus down --boundaries all-monitors-outer-frame";
    "${mod}-1" = "workspace 1";
    "${mod}-2" = "workspace 2";
    "${mod}-3" = "workspace 3";
    "${mod}-4" = "workspace 4";
    "${mod}-5" = "workspace 5";
    "${mod}-6" = "workspace 6";
    "${mod}-7" = "workspace 7";
    "${mod}-8" = "workspace 8";
    "${mod}-9" = "workspace 9";
    "${mod}-backtick" = "workspace ai";

    "${mod}-shift-left" = "move left";
    "${mod}-shift-right" = "move right";
    "${mod}-shift-up" = "move up";
    "${mod}-shift-down" = "move down";
    "${mod}-shift-h" = "move left";
    "${mod}-shift-l" = "move right";
    "${mod}-shift-j" = "move down";
    "${mod}-shift-k" = "move up";
    "${mod}-shift-1" = "move-node-to-workspace 1";
    "${mod}-shift-2" = "move-node-to-workspace 2";
    "${mod}-shift-3" = "move-node-to-workspace 3";
    "${mod}-shift-4" = "move-node-to-workspace 4";
    "${mod}-shift-5" = "move-node-to-workspace 5";
    "${mod}-shift-6" = "move-node-to-workspace 6";
    "${mod}-shift-7" = "move-node-to-workspace 7";
    "${mod}-shift-8" = "move-node-to-workspace 8";
    "${mod}-shift-9" = "move-node-to-workspace 9";
    "${mod}-shift-backtick" = "move-node-to-workspace ai";

    "${mod}-ctrl-left" = "resize width -50";
    "${mod}-ctrl-right" = "resize width +50";
    "${mod}-ctrl-up" = "resize height +50";
    "${mod}-ctrl-down" = "resize height -50";
    "${mod}-ctrl-h" = "resize width -50";
    "${mod}-ctrl-l" = "resize width +50";
    "${mod}-ctrl-k" = "resize height +50";
    "${mod}-ctrl-j" = "resize height -50";

    # workspace cycling, mirrors hyprland super+period/comma and super+tab
    # (cmd-tab is reserved by macos, so back-and-forth lives on alt-tab)
    "${mod}-period" = "workspace --wrap-around next";
    "${mod}-comma" = "workspace --wrap-around prev";
    alt-tab = "workspace-back-and-forth";

    # window management, mirrors hyprland super-ctrl+backspace/super+space/
    # super+s (cmd-space is raycast and cmd-s is save, so those get
    # shift/alt instead). cmd-q is intentionally unbound: native macos quit
    # everywhere — ghostty rebinds its own super+q=quit since
    # clearDefaultKeybinds removes it
    "${mod}-ctrl-backspace" = "close";
    "${mod}-shift-space" = "layout floating tiling";
    alt-s = "layout tiles horizontal vertical";
    alt-f = "fullscreen";

    # launchers, mirrors hyprland super+{b,return,e,d,escape} super-shift+{p,n,e}
    "${mod}-b" = "exec-and-forget open -b app.zen-browser.zen";
    "${mod}-enter" = "exec-and-forget open -na Ghostty";
    "${mod}-e" = "exec-and-forget open -na Ghostty --args -e nvim";
    "${mod}-esc" = "exec-and-forget open -na Ghostty --args --title=BTOP -e /etc/profiles/per-user/${admin.name}/bin/btop";
    "${mod}-shift-p" = "exec-and-forget open -b com.1password.1password";
    "${mod}-shift-n" = "exec-and-forget open -b md.obsidian";
    "${mod}-shift-e" = "exec-and-forget open -a Finder $HOME";
    "${mod}-d" = "exec-and-forget open -a ${getExe pkgs.vesktop}";
  };
}
