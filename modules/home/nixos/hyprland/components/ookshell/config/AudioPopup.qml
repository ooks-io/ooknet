pragma Singleton

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

// audio popover anchored under the bar speaker icon. rendered inside a full-screen
// layer-shell overlay (same approach as TrayMenu, avoids the flicky xdg popup) with
// click-away dismiss. output + input device switchers, volume sliders, mute toggles
Singleton {
    id: root

    property bool active: false

    function toggle() {
        root.active = !root.active;
    }
    function close() {
        root.active = false;
    }

    // one selectable device row (matches TrayMenu's MenuRow idiom)
    component DeviceRow: Rectangle {
        property var node: null
        property bool current: false
        signal chosen

        Layout.fillWidth: true
        implicitHeight: 24
        radius: 4
        color: dHover.hovered ? Config.trayMenuHover : "transparent"

        Row {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 6
            anchors.rightMargin: 6
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: 9
                height: 9
                radius: 4.5
                color: current ? Config.primary : "transparent"
                border.width: 1
                border.color: current ? Config.primary : Config.border
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 17
                text: Audio.label(node)
                elide: Text.ElideRight
                font.family: Config.fontFamily
                font.pixelSize: Config.fontSize - 1
                color: current ? Config.text : Qt.rgba(1, 1, 1, 0.7)
            }
        }

        HoverHandler {
            id: dHover
        }
        MouseArea {
            anchors.fill: parent
            onClicked: parent.chosen()
        }
    }

    // volume slider with % readout; drag or scroll
    component VolumeRow: Item {
        property real value: 0
        property bool muted: false
        signal moved(real v)
        signal scrolled(real delta)

        Layout.fillWidth: true
        implicitHeight: 20

        Text {
            id: rowPct
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: 34
            horizontalAlignment: Text.AlignRight
            text: Math.round(parent.value * 100) + "%"
            font.family: Config.fontFamily
            font.pixelSize: Config.fontSize - 2
            color: parent.muted ? Config.urgent : Config.text
        }

        Item {
            anchors.left: parent.left
            anchors.right: rowPct.left
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height

            Rectangle {
                id: rowTrack
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                height: 6
                radius: 3
                color: Config.border

                Rectangle {
                    width: rowTrack.width * Math.max(0, Math.min(1, value))
                    height: parent.height
                    radius: 3
                    color: muted ? Config.urgent : Config.primary
                }
            }

            MouseArea {
                id: rowMouse
                anchors.fill: parent
                onPressed: e => moved(e.x / rowMouse.width)
                onPositionChanged: e => {
                    if (pressed)
                        moved(e.x / rowMouse.width);
                }
            }
            WheelHandler {
                onWheel: e => scrolled(e.angleDelta.y > 0 ? 0.05 : -0.05)
            }
        }
    }

    // mute/unmute style toggle button
    component ToggleBtn: Rectangle {
        property bool on: false
        property string offText: "mute"
        property string onText: "unmute"
        signal toggled

        Layout.fillWidth: true
        implicitHeight: 24
        radius: 4
        color: tHover.hovered ? Config.trayMenuHover : "transparent"
        border.width: 1
        border.color: Config.border

        Text {
            anchors.centerIn: parent
            text: parent.on ? parent.onText : parent.offText
            font.family: Config.fontFamily
            font.pixelSize: Config.fontSize - 1
            color: parent.on ? Config.urgent : Config.text
        }

        HoverHandler {
            id: tHover
        }
        MouseArea {
            anchors.fill: parent
            onClicked: parent.toggled()
        }
    }

    component SectionLabel: Text {
        font.family: Config.fontFamily
        font.pixelSize: Config.fontSize - 2
        color: Config.text
        opacity: 0.55
    }

    PanelWindow {
        id: overlay
        visible: root.active
        color: "transparent"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "ookshell-audio"

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        exclusiveZone: -1 // span the full output so coords match the tiled-window grid

        // backdrop: click anywhere outside the frame dismisses
        MouseArea {
            anchors.fill: parent
            onClicked: root.close()
        }

        Rectangle {
            id: frame
            // top-right corner aligned to the tiled-window corner: flush below the
            // bar, inset by the hyprland gap on the right -- lines up with windows
            x: overlay.width - width - Config.dashGap
            y: Config.barMarginTop + Config.barHeight
            width: 264
            height: col.implicitHeight + Config.trayMenuPadding * 2
            color: Config.trayMenuBg
            radius: Config.frameRounding
            border.width: Config.frameBorderWidth
            border.color: Config.frameBorder
            clip: true

            MouseArea {
                anchors.fill: parent // swallow clicks so they don't hit the backdrop
            }

            ColumnLayout {
                id: col
                x: Config.trayMenuPadding
                y: Config.trayMenuPadding
                width: frame.width - Config.trayMenuPadding * 2
                spacing: 4

                SectionLabel {
                    text: "output"
                }

                Repeater {
                    model: Audio.sinks
                    delegate: DeviceRow {
                        required property var modelData
                        node: modelData
                        current: Audio.sink && Audio.sink.id === modelData.id
                        onChosen: Audio.setSink(modelData)
                    }
                }

                VolumeRow {
                    Layout.topMargin: 4
                    value: Audio.volume
                    muted: Audio.muted
                    onMoved: v => Audio.setVolume(v)
                    onScrolled: d => Audio.changeVolume(d)
                }

                ToggleBtn {
                    Layout.topMargin: 2
                    on: Audio.muted
                    onToggled: Audio.toggleMute()
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.topMargin: 6
                    Layout.bottomMargin: 2
                    Layout.preferredHeight: 1
                    color: Config.border
                    opacity: 0.5
                }

                SectionLabel {
                    text: "input"
                }

                Repeater {
                    model: Audio.sources
                    delegate: DeviceRow {
                        required property var modelData
                        node: modelData
                        current: Audio.source && Audio.source.id === modelData.id
                        onChosen: Audio.setSource(modelData)
                    }
                }

                VolumeRow {
                    Layout.topMargin: 4
                    value: Audio.sourceVolume
                    muted: Audio.sourceMuted
                    onMoved: v => Audio.setSourceVolume(v)
                    onScrolled: d => Audio.changeSourceVolume(d)
                }

                ToggleBtn {
                    Layout.topMargin: 2
                    on: Audio.sourceMuted
                    onToggled: Audio.toggleSourceMute()
                }
            }
        }
    }
}
