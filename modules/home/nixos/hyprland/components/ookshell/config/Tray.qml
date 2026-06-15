import QtQuick
import Quickshell.Services.SystemTray

// compact tray: collapses to a single chevron at the bar's right edge; clicking
// it toggles the icons, which fan out to the left. set tray.compact = false to
// always show the icons (plain row, original behaviour).
Row {
    id: root
    spacing: Config.traySpacing

    property bool compact: Config.trayCompact
    property bool open: false
    property bool expanded: root.open || !compact
    readonly property int count: iconsRepeater.count

    // revealed icons. width animates 0 <-> content; clipped + right-anchored so
    // they wipe in from the chevron leftward. no space reserved when collapsed.
    Item {
        id: iconsWrap
        height: Config.trayIconSize
        clip: true
        width: root.expanded ? iconsRow.implicitWidth : 0
        opacity: root.expanded ? 1 : 0
        visible: root.count > 0 && (width > 0 || opacity > 0)

        Behavior on width {
            NumberAnimation {
                duration: 160
                easing.type: Easing.OutCubic
            }
        }
        Behavior on opacity {
            NumberAnimation {
                duration: 120
            }
        }

        Row {
            id: iconsRow
            anchors.right: parent.right
            height: parent.height
            spacing: Config.traySpacing

            Repeater {
                id: iconsRepeater
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
    }

    // stationary toggle target. only present in compact mode with items to reveal.
    // chevron points left when collapsed, flips when expanded.
    Item {
        id: chevron
        width: Config.trayIconSize
        height: Config.trayIconSize
        visible: root.compact && root.count > 0

        Text {
            anchors.centerIn: parent
            font.family: Config.fontFamily
            font.pixelSize: Config.fontSize
            color: root.open ? Config.primary : Config.text
            text: "\u{f053}" // nf-fa-chevron_left
            rotation: root.expanded ? 180 : 0

            Behavior on rotation {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.open = !root.open
        }
    }
}
