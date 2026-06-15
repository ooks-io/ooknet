import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: bar
    color: "transparent"

    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: Config.barMarginTop
        left: Config.barMarginLeft
        right: Config.barMarginRight
    }

    implicitHeight: Config.barHeight
    exclusiveZone: Config.barExclusive

    // left cluster: clock | battery | workspaces -- top corners rounded, bottom
    // edge straight so it sits flush against the window below
    Rectangle {
        id: leftCluster
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: leftRow.implicitWidth + Config.barPadding * 2
        radius: Config.barRadius
        bottomLeftRadius: 0
        bottomRightRadius: 0
        color: Config.bg
        border.color: Config.border
        border.width: Config.barBorder

        RowLayout {
            id: leftRow
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: Config.barPadding
            spacing: Config.barSpacing

            Clock {Layout.alignment: Qt.AlignVCenter}

            Rectangle {
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 1
                Layout.preferredHeight: Config.barHeight / 2
                color: Config.border
            }

            Battery {
                id: batteryItem
                Layout.alignment: Qt.AlignVCenter
            }

            Rectangle {
                visible: batteryItem.visible
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 1
                Layout.preferredHeight: Config.barHeight / 2
                color: Config.border
            }

            Workspaces {Layout.alignment: Qt.AlignVCenter}
        }
    }

    // right cluster: machines + services dashboard buttons, record indicator, tray
    Row {
        anchors.right: parent.right
        anchors.rightMargin: Config.barSpacing
        anchors.verticalCenter: parent.verticalCenter
        spacing: Config.barSpacing

        // machines view
        Item {
            width: Config.trayIconSize
            height: Config.trayIconSize
            Text {
                anchors.centerIn: parent
                font.family: Config.fontFamily
                font.pixelSize: Config.fontSize
                text: "" // nf-fa-server
                color: Monitor.open && Monitor.view === "machines" ? Config.primary : Config.text
            }
            MouseArea {
                anchors.fill: parent
                onClicked: Monitor.show("machines")
            }
        }

        // services view -- glyph colour also reflects aggregate health
        Item {
            width: Config.trayIconSize
            height: Config.trayIconSize
            Text {
                anchors.centerIn: parent
                font.family: Config.fontFamily
                font.pixelSize: Config.fontSize
                text: "" // nf-fa-heartbeat
                color: Monitor.open && Monitor.view === "services" ? Config.primary : Monitor.health === "crit" ? Config.urgent : Monitor.health === "warn" ? Config.batWarn : Config.text
            }
            MouseArea {
                anchors.fill: parent
                onClicked: Monitor.show("services")
            }
        }

        // notification history
        Item {
            width: Config.trayIconSize
            height: Config.trayIconSize
            Text {
                anchors.centerIn: parent
                font.family: Config.fontFamily
                font.pixelSize: Config.fontSize
                text: "" // nf-fa-bell
                color: Monitor.open && Monitor.view === "notifications" ? Config.primary : Config.text
            }
            MouseArea {
                anchors.fill: parent
                onClicked: Monitor.show("notifications")
            }
        }

        // audio: click opens the output/volume popover, scroll adjusts volume.
        // glyph reflects mute + level (off / low / high)
        Item {
            id: audioBtn
            width: Config.trayIconSize
            height: Config.trayIconSize
            Text {
                anchors.centerIn: parent
                font.family: Config.fontFamily
                font.pixelSize: Config.fontSize
                // nf-fa volume_off / volume_down / volume_up
                text: (Audio.muted || Audio.volume <= 0) ? "\u{f026}" : Audio.volume < 0.5 ? "\u{f027}" : "\u{f028}"
                color: AudioPopup.active ? Config.primary : Audio.muted ? Config.urgent : Config.text
            }
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                onClicked: (mouse) => {
                    if (mouse.button === Qt.MiddleButton)
                        Audio.toggleMute();
                    else
                        AudioPopup.toggle();
                }
            }
            WheelHandler {
                onWheel: (e) => Audio.changeVolume(e.angleDelta.y > 0 ? 0.05 : -0.05)
            }
        }

        HyprRecord {}
        Tray {}
    }
}
