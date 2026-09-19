{
  config,
  lib,
  ...
}: let
  inherit (config.ooknet) binds;
  inherit (lib) concatStringsSep mapAttrsToList;
  inherit (builtins) toJSON;
  toLua = lib.generators.toLua {};

  bind = key: dsp: "hl.bind(${toJSON key}, ${dsp})";
  bindWith = flags: key: dsp: "hl.bind(${toJSON key}, ${dsp}, ${toLua flags})";
  exec = cmd: "hl.dsp.exec_cmd(${toJSON cmd})";

  dirs = {
    left = "l";
    right = "r";
    up = "u";
    down = "d";
    h = "l";
    l = "r";
    k = "u";
    j = "d";
  };
  resize = {
    left = "x = -20, y = 0";
    right = "x = 20, y = 0";
    up = "x = 0, y = -20";
    down = "x = 0, y = 20";
  };

  lines =
    [
      "-- programs"
      (bind "SUPER + b" (exec binds.browser))
      (bind "SUPER + return" (exec binds.terminal))
      (bind "SUPER + SHIFT + return" (exec "${binds.terminal} --title=dropdown"))
      (bind "SUPER + e" (exec "${binds.terminalLaunch} $EDITOR"))
      (bind "SUPER + SHIFT + P" (exec binds.password))
      (bind "SUPER + CTRL + P" (exec binds.quickpass))
      (bind "SUPER + d" (exec binds.discord))
      (bind "SUPER + SHIFT + e" (exec binds.fileManager))
      (bind "SUPER + SHIFT + S" (exec binds.steam))
      (bind "SUPER + SHIFT + n" (exec binds.notes))
      (bind "SUPER + escape" (exec binds.btop))
      (bind "SUPER + CTRL + return" (exec binds.zellijMenu))
      (bind "SUPER + delete" (exec binds.powerMenu))
      (bind "SUPER + SHIFT + F" (exec binds.factorio))
      (bind "SUPER + Backspace" (exec binds.lock))

      "-- spotify"
      (bind "SUPER + M" (exec binds.spotify.launch))
      (bind "SUPER + bracketright" (exec binds.spotify.next))
      (bind "SUPER + bracketleft" (exec binds.spotify.previous))
      (bind "SUPER + backslash" (exec binds.spotify.play))

      "-- brightness / volume"
      (bind "XF86MonBrightnessUp" (exec binds.brightness.up))
      (bind "XF86MonBrightnessDown" (exec binds.brightness.down))
      (bind "XF86AudioRaiseVolume" (exec binds.volume.up))
      (bind "XF86AudioLowerVolume" (exec binds.volume.down))
      (bind "XF86AudioMute" (exec binds.volume.mute))

      "-- window management"
      (bind "SUPER + Q" "hl.dsp.window.close()")
      (bind "SUPER + CTRL + backspace" "hl.dsp.window.close()")
      (bind "SUPER + SHIFT + ALT + delete" (exec "hyprkillsession"))
      (bind "SUPER + F" "hl.dsp.window.fullscreen()")
      # was `fullscreenstate` with no args, a noop in hyprlang too
      (bind "SUPER + CTRL + F" "hl.dsp.window.fullscreen_state({ internal = -1, client = -1 })")
      (bind "SUPER + Space" "hl.dsp.window.float()")
      (bind "SUPER + P" "hl.dsp.window.pseudo()")
      (bind "SUPER + S" ''hl.dsp.layout("togglesplit")'')

      "-- focus"
    ]
    ++ mapAttrsToList (k: d: bind "SUPER + ${k}" ''hl.dsp.focus({ direction = "${d}" })'') dirs
    ++ ["-- move"]
    ++ mapAttrsToList (k: d: bind "SUPER + SHIFT + ${k}" ''hl.dsp.window.move({ direction = "${d}" })'') dirs
    ++ ["-- resize"]
    ++ mapAttrsToList (k: xy: bind "SUPER + CTRL + ${k}" "hl.dsp.window.resize({ ${xy}, relative = true })") resize
    ++ [
      ''
        -- workspaces
        for i = 1, 10 do
          local key = i % 10
          hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
          hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
        end''
      (bind "SUPER + period" ''hl.dsp.focus({ workspace = "e+1" })'')
      (bind "SUPER + comma" ''hl.dsp.focus({ workspace = "e-1" })'')
      (bind "SUPER + tab" "hl.dsp.focus({ last = true })")

      "-- mouse"
      (bindWith {mouse = true;} "SUPER + mouse:272" "hl.dsp.window.drag()")
      (bindWith {mouse = true;} "SUPER + mouse:273" "hl.dsp.window.resize()")

      ''
        -- cursor zoom
        local function zoom(mult)
          return function()
            local z = hl.get_config("cursor.zoom_factor")
            if z < 1 then z = 1 end
            hl.config({ ["cursor.zoom_factor"] = z * mult })
          end
        end''
      (bind "SUPER + SHIFT + mouse_down" "zoom(1.25)")
      (bind "SUPER + SHIFT + mouse_up" "zoom(1 / 1.25)")
    ];
in {
  wayland.windowManager.hyprland.extraLuaFiles.binds.content = concatStringsSep "\n" lines + "\n";
}
