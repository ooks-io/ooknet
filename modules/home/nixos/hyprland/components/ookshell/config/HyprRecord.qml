import QtQuick
import Quickshell
import Quickshell.Io

// red record glyph, only shown while wl-screenrec is running
Item {
    id: root
    property bool recording: false

    implicitWidth: recording ? icon.implicitWidth : 0
    implicitHeight: icon.implicitHeight
    visible: recording

    Process {
        id: probe
        command: ["pgrep", "wl-screenrec"]
        onExited: (code) => root.recording = (code === 0)
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: if (!probe.running) probe.running = true
    }

    Text {
        id: icon
        font.family: Config.fontFamily
        font.pixelSize: Config.fontSize
        color: Config.record
        text: "\u{f03d}"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: Quickshell.execDetached(["hyprrecord", "-a", "--waybar", "screen", "copysave", "video"])
    }
}
