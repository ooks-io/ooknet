import QtQuick
import Quickshell.Services.SystemTray

Row {
    id: root
    spacing: Config.traySpacing

    Repeater {
        model: SystemTray.items

        delegate: Item {
            id: iconItem
            required property var modelData
            width: Config.trayIconSize
            height: Config.trayIconSize

            Image {
                anchors.fill: parent
                source: modelData.icon
                sourceSize.width: Config.trayIconSize
                sourceSize.height: Config.trayIconSize
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
                onClicked: (mouse) => {
                    if (mouse.button === Qt.LeftButton) modelData.activate();
                    else if (mouse.button === Qt.MiddleButton) modelData.secondaryActivate();
                    else if (mouse.button === Qt.RightButton && modelData.hasMenu) {
                        const p = iconItem.mapToGlobal(iconItem.width, iconItem.height);
                        TrayMenu.openAt(modelData.menu, p.x, p.y);
                    }
                }
            }
        }
    }
}
