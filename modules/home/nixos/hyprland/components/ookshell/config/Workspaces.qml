import QtQuick
import Quickshell.Hyprland

Row {
    id: root
    spacing: Config.wsSpacing

    Repeater {
        // persistent set (1..N) unioned with any existing workspaces, so
        // extras like ws 7 show up dynamically
        model: {
            const ids = ({});
            const n = Config.wsPersistent;
            for (let i = 1; i <= n; i++)
                ids[i] = true;
            const list = Hyprland.workspaces.values;
            for (let i = 0; i < list.length; i++)
                if (list[i].id > 0)
                    ids[list[i].id] = true;
            return Object.keys(ids).map(Number).sort((a, b) => a - b);
        }

        delegate: Text {
            id: wsItem
            required property var modelData
            readonly property int wsId: modelData
            readonly property var hw: {
                const list = Hyprland.workspaces.values;
                for (let i = 0; i < list.length; i++)
                    if (list[i].id === wsId) return list[i];
                return null;
            }
            readonly property bool active: hw ? hw.focused : false
            readonly property bool urgent: hw ? hw.urgent : false

            font.family: Config.fontFamily
            font.pixelSize: Config.fontSize
            text: urgent ? "\u{f06a}" : active ? "\u{f111}" : "\u{f10c}"
            color: urgent ? Config.urgent : active ? Config.primary : Config.text

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + wsItem.wsId)
            }
        }
    }

    WheelHandler {
        onWheel: (event) => {
            Hyprland.dispatch(event.angleDelta.y > 0 ? "workspace m+1" : "workspace m-1");
        }
    }
}
