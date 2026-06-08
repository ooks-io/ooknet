import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: win
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay

    anchors {
        top: true
        right: true
    }
    margins {
        top: Config.notifMarginTop
        right: Config.notifMarginRight
    }

    // size to the stack; 0 when empty so nothing is shown / clickable
    implicitWidth: Math.max(1, column.implicitWidth)
    implicitHeight: Math.max(1, column.implicitHeight)
    exclusiveZone: 0

    Column {
        id: column
        anchors.right: parent.right
        spacing: Config.notifSpacing

        Repeater {
            // newest on top, capped at maxVisible
            model: {
                const all = Notifications.list.values;
                return all.slice().reverse().slice(0, Config.notifMaxVisible);
            }

            delegate: NotificationCard {
                required property var modelData
                notif: modelData
            }
        }
    }
}
