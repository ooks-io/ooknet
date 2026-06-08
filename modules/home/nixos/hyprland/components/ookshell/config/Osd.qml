pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

// tracks volume / mic / brightness and exposes the current value for the OSD
Singleton {
    id: root

    property string kind: "Volume"
    property real value: 0
    property bool muted: false
    property bool active: false
    property bool ready: false // suppress OSD during initial property population

    function show(k, v, m) {
        root.kind = k;
        root.value = v;
        root.muted = m;
        root.active = true;
        hideTimer.restart();
    }

    Timer {
        id: hideTimer
        interval: Config.osdTimeout
        onTriggered: root.active = false
    }

    Timer {
        interval: 1000
        running: true
        onTriggered: root.ready = true
    }

    // keep the default sink/source bound so volume/muted stay live
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }

    function showSink() {
        const a = Pipewire.defaultAudioSink?.audio;
        if (root.ready && a) root.show("Volume", a.volume, a.muted);
    }

    Connections {
        target: Pipewire.defaultAudioSink?.audio ?? null
        function onVolumesChanged() { root.showSink(); }
        function onMutedChanged() { root.showSink(); }
    }

    Connections {
        target: Pipewire.defaultAudioSource?.audio ?? null
        function onMutedChanged() {
            const a = Pipewire.defaultAudioSource?.audio;
            if (root.ready && a) root.show("Mic", a.muted ? 0 : 1, a.muted);
        }
    }

    // ---- brightness via sysfs (works where a backlight device exists) ----
    property string backlightDev: ""
    property int brightnessMax: 1
    readonly property string brightnessFile: backlightDev ? "/sys/class/backlight/" + backlightDev + "/brightness" : ""
    readonly property string maxFile: backlightDev ? "/sys/class/backlight/" + backlightDev + "/max_brightness" : ""

    Process {
        running: true
        command: ["sh", "-c", "ls -1 /sys/class/backlight 2>/dev/null | head -1"]
        stdout: SplitParser {
            onRead: line => {
                if (line.trim().length) root.backlightDev = line.trim();
            }
        }
    }

    FileView {
        path: root.maxFile
        blockLoading: true
        onLoaded: root.brightnessMax = parseInt(text()) || 1
    }

    FileView {
        path: root.brightnessFile
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            const cur = parseInt(text()) || 0;
            if (root.ready && root.brightnessMax > 0)
                root.show("Brightness", cur / root.brightnessMax, false);
        }
    }
}
