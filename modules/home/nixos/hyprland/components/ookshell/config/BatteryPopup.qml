pragma Singleton

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.UPower

// battery popover anchored under the bar battery item. same full-screen
// layer-shell overlay + click-away idiom as AudioPopup, but top-left aligned
// (battery lives in the left cluster). read-only: health, rate, time, capacity
Singleton {
    id: root

    property bool active: false

    function toggle() {
        root.active = !root.active;
    }
    function close() {
        root.active = false;
    }

    readonly property var dev: UPower.displayDevice
    readonly property int pct: dev ? Math.round(dev.percentage * 100) : 0
    readonly property int st: dev ? dev.state : UPowerDeviceState.Unknown
    readonly property bool charging: st === UPowerDeviceState.Charging
        || st === UPowerDeviceState.FullyCharged

    readonly property color levelColor: pct <= 15 ? Config.batCrit
        : pct <= 35 ? Config.batWarn
        : Config.batGood

    function fmtTime(s) {
        if (!s || s <= 0)
            return "–";
        const h = Math.floor(s / 3600);
        const m = Math.floor((s % 3600) / 60);
        return h > 0 ? h + "h " + m + "m" : m + "m";
    }

    function stateText(s) {
        switch (s) {
        case UPowerDeviceState.Charging:
            return "charging";
        case UPowerDeviceState.Discharging:
            return "discharging";
        case UPowerDeviceState.FullyCharged:
            return "full";
        case UPowerDeviceState.PendingCharge:
            return "pending charge";
        case UPowerDeviceState.PendingDischarge:
            return "pending discharge";
        case UPowerDeviceState.Empty:
            return "empty";
        default:
            return "unknown";
        }
    }

    // label left, value right -- one metric per line
    component InfoRow: RowLayout {
        property string label: ""
        property string value: ""
        property color valueColor: Config.text

        Layout.fillWidth: true
        spacing: 8

        Text {
            text: label
            font.family: Config.fontFamily
            font.pixelSize: Config.fontSize - 1
            color: Config.text
            opacity: 0.55
        }
        Item {
            Layout.fillWidth: true
        }
        Text {
            text: value
            font.family: Config.fontFamily
            font.pixelSize: Config.fontSize - 1
            color: valueColor
        }
    }

    PanelWindow {
        id: overlay
        visible: root.active
        color: "transparent"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "ookshell-battery"

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        exclusiveZone: -1

        MouseArea {
            anchors.fill: parent
            onClicked: root.close()
        }

        Rectangle {
            id: frame
            // top-left corner flush below the bar, aligned to the left cluster edge
            x: Config.barMarginLeft
            y: Config.barMarginTop + Config.barHeight
            width: 224
            height: col.implicitHeight + Config.trayMenuPadding * 2
            color: Config.trayMenuBg
            radius: Config.frameRounding
            border.width: Config.frameBorderWidth
            border.color: Config.frameBorder
            clip: true

            MouseArea {
                anchors.fill: parent // swallow clicks so they don't dismiss
            }

            ColumnLayout {
                id: col
                x: Config.trayMenuPadding
                y: Config.trayMenuPadding
                width: frame.width - Config.trayMenuPadding * 2
                spacing: 4

                // header: big percentage + charge state
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 6

                    Text {
                        text: root.pct + "%"
                        font.family: Config.fontFamily
                        font.pixelSize: Config.fontSize + 10
                        color: root.levelColor
                    }
                    Item {
                        Layout.fillWidth: true
                    }
                    Text {
                        text: (root.charging ? "\u{f140b} " : "") + root.stateText(root.st)
                        font.family: Config.fontFamily
                        font.pixelSize: Config.fontSize - 1
                        color: root.charging ? Config.batGood : Config.text
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.topMargin: 4
                    Layout.bottomMargin: 4
                    Layout.preferredHeight: 1
                    color: Config.border
                    opacity: 0.5
                }

                InfoRow {
                    label: root.charging ? "time to full" : "time to empty"
                    value: root.fmtTime(root.charging ? (root.dev ? root.dev.timeToFull : 0) : (root.dev ? root.dev.timeToEmpty : 0))
                }
                InfoRow {
                    label: root.charging ? "charge rate" : "draw"
                    value: root.dev ? Math.abs(root.dev.changeRate).toFixed(1) + " W" : "–"
                }
                InfoRow {
                    label: "capacity"
                    value: root.dev ? root.dev.energy.toFixed(1) + " / " + root.dev.energyCapacity.toFixed(1) + " Wh" : "–"
                }
                InfoRow {
                    label: "health"
                    value: (root.dev && root.dev.healthSupported) ? Math.round(root.dev.healthPercentage) + "%" : "n/a"
                    valueColor: (root.dev && root.dev.healthSupported)
                        ? (root.dev.healthPercentage >= 80 ? Config.batGood
                            : root.dev.healthPercentage >= 60 ? Config.batWarn
                            : Config.batCrit)
                        : Config.text
                }
            }
        }
    }
}
