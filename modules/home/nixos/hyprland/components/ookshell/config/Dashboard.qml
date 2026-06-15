import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

// right slide-out pane showing the tailnet machines from ooknet-monitor.
// full-screen overlay so it can dim + click-away to close; the panel translates
// in from the right edge.
PanelWindow {
    id: win
    visible: Monitor.open || panel.x < win.width
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "ookshell-dashboard"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    // iso (2026-09-30...) -> au dd/mm/yyyy
    function fmtDate(iso) {
        if (!iso)
            return "";
        const p = iso.slice(0, 10).split("-"); // [yyyy, mm, dd]
        return p.length === 3 ? p[2] + "/" + p[1] + "/" + p[0] : iso.slice(0, 10);
    }
    function isExpired(iso) {
        return !!iso && new Date(iso).getTime() < Date.now();
    }
    function fmtUptime(s) {
        if (!s)
            return "";
        const d = Math.floor(s / 86400), h = Math.floor(s % 86400 / 3600);
        if (d > 0)
            return d + "d";
        if (h > 0)
            return h + "h";
        return Math.floor(s / 60) + "m";
    }
    // iso ts -> compact relative age (now / 5m / 3h / 2d), else short date
    function notifTime(iso) {
        if (!iso)
            return "";
        const s = Math.floor((Date.now() - new Date(iso).getTime()) / 1000);
        if (s < 60)
            return "now";
        if (s < 3600)
            return Math.floor(s / 60) + "m";
        if (s < 86400)
            return Math.floor(s / 3600) + "h";
        if (s < 604800)
            return Math.floor(s / 86400) + "d";
        return fmtDate(iso);
    }
    // strip unicode directional-isolate chars (discord uses them) so they don't render as boxes
    function clean(t) {
        return (t || "").replace(/[\u2066-\u2069]/g, "");
    }
    // nerd glyph per os. this fleet's linux boxes are all nixos
    function osGlyph(os) {
        switch ((os || "").toLowerCase()) {
        case "linux":
            return ""; // nixos
        case "macos":
            return ""; // apple
        case "android":
            return ""; // android
        case "windows":
            return ""; // windows
        default:
            return ""; // generic device
        }
    }

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    exclusiveZone: -1 // span the full screen (ignore the bar's reserved zone) so the dim covers the top too

    // dim backdrop, click anywhere to dismiss
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: Monitor.open ? 0.35 : 0
        Behavior on opacity {
            NumberAnimation {
                duration: 200
            }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: Monitor.open = false
        }
    }

    Rectangle {
        id: panel
        width: Config.dashWidth
        // inset by the hyprland window gap on top/bottom/right so it aligns with
        // tiled windows; wears the shared window frame (rounding/border)
        // window now spans from screen top, so clear the bar (flush below it, like a tiled window)
        anchors.top: parent.top
        anchors.topMargin: Config.barMarginTop + Config.barHeight
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Config.dashGap
        x: Monitor.open ? parent.width - width - Config.dashGap : parent.width
        Behavior on x {
            NumberAnimation {
                duration: 240
                easing.type: Easing.OutCubic
            }
        }

        clip: true
        color: Config.bg
        radius: Config.frameRounding
        border.color: Config.frameBorder
        border.width: Config.frameBorderWidth

        MouseArea {
            anchors.fill: parent // swallow clicks so they don't hit the backdrop
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Config.barPadding
            spacing: Config.barSpacing

            // header
            RowLayout {
                Layout.fillWidth: true
                Text {
                    Layout.fillWidth: true
                    text: Monitor.view
                    font.family: Config.fontFamily
                    font.pixelSize: Config.fontSize + 3
                    font.bold: true
                    color: Config.text
                }
                Text {
                    text: Monitor.view === "notifications" ? NotifHistory.items.length + " logged" : Monitor.view === "services" ? Monitor.services.filter(s => s.status === "up").length + "/" + Monitor.services.length + " up" : [].concat(Monitor.machines).filter(m => m.online).length + "/" + Monitor.machines.length + " up"
                    font.family: Config.fontFamily
                    font.pixelSize: Config.fontSize - 2
                    color: Config.text
                    opacity: 0.6
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: Config.border
            }

            // machines view
            ListView {
                visible: Monitor.view === "machines"
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 6
                model: Monitor.machines

                delegate: Rectangle {
                    id: card
                    required property var modelData
                    width: ListView.view.width
                    implicitHeight: cardCol.implicitHeight + 16
                    radius: 6
                    color: Qt.rgba(1, 1, 1, 0.04)
                    border.width: 1
                    border.color: Config.border

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 8

                        Rectangle {
                            Layout.alignment: Qt.AlignTop
                            Layout.topMargin: 4
                            width: 9
                            height: 9
                            radius: 4.5
                            color: card.modelData.online ? Config.batGood : Config.urgent
                        }

                        ColumnLayout {
                            id: cardCol
                            Layout.fillWidth: true
                            spacing: 2

                            RowLayout {
                                Layout.fillWidth: true
                                Text {
                                    text: card.modelData.hostname ?? "?"
                                    font.family: Config.fontFamily
                                    font.pixelSize: Config.fontSize
                                    font.bold: true
                                    color: Config.text
                                }
                                Item {
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: win.osGlyph(card.modelData.os)
                                    font.family: Config.fontFamily
                                    font.pixelSize: Config.fontSize
                                    color: Config.text
                                    opacity: 0.7
                                }
                            }

                            Text {
                                text: card.modelData.ip ?? ""
                                font.family: Config.fontFamily
                                font.pixelSize: Config.fontSize - 2
                                color: Config.text
                                opacity: 0.55
                            }

                            // host data from ssh (kernel · uptime), nixos hosts only
                            Text {
                                visible: !!card.modelData.kernel
                                text: (card.modelData.kernel ?? "") + (card.modelData.uptimeSec ? "  ·  up " + win.fmtUptime(card.modelData.uptimeSec) : "")
                                font.family: Config.fontFamily
                                font.pixelSize: Config.fontSize - 3
                                color: Config.text
                                opacity: 0.45
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 6
                                Text {
                                    visible: card.modelData.ssh === true
                                    text: "SSH"
                                    font.family: Config.fontFamily
                                    font.pixelSize: Config.fontSize - 4
                                    color: Config.primary
                                }
                                Text {
                                    visible: !!card.modelData.keyExpiry
                                    text: "exp " + win.fmtDate(card.modelData.keyExpiry)
                                    font.family: Config.fontFamily
                                    font.pixelSize: Config.fontSize - 4
                                    color: win.isExpired(card.modelData.keyExpiry) ? Config.urgent : Config.text
                                    opacity: win.isExpired(card.modelData.keyExpiry) ? 0.9 : 0.45
                                }
                                Item {
                                    Layout.fillWidth: true
                                }
                                Text {
                                    visible: !card.modelData.online && !!card.modelData.lastSeen
                                    text: card.modelData.lastSeen ? "seen " + win.fmtDate(card.modelData.lastSeen) : ""
                                    font.family: Config.fontFamily
                                    font.pixelSize: Config.fontSize - 4
                                    color: Config.text
                                    opacity: 0.45
                                }
                            }
                        }
                    }
                }
            }

            // services view
            ListView {
                visible: Monitor.view === "services"
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 6
                model: Monitor.services

                delegate: Rectangle {
                    id: svc
                    required property var modelData
                    property bool expanded: false
                    width: ListView.view.width
                    implicitHeight: svcCol.implicitHeight + 16
                    radius: 6
                    color: Qt.rgba(1, 1, 1, svc.expanded ? 0.07 : 0.04)
                    border.width: 1
                    border.color: Config.border
                    clip: true

                    Behavior on implicitHeight {
                        NumberAnimation {
                            duration: 130
                            easing.type: Easing.OutCubic
                        }
                    }

                    ColumnLayout {
                        id: svcCol
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 6

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10

                            Rectangle {
                                Layout.alignment: Qt.AlignVCenter
                                width: 9
                                height: 9
                                radius: 4.5
                                color: svc.modelData.status === "up" ? Config.batGood : svc.modelData.status === "degraded" ? Config.batWarn : Config.urgent
                            }

                            Text {
                                Layout.fillWidth: true
                                text: svc.modelData.name ?? "?"
                                elide: Text.ElideRight
                                font.family: Config.fontFamily
                                font.pixelSize: Config.fontSize
                                font.bold: true
                                color: Config.text
                            }

                            Text {
                                text: svc.modelData.detail ?? ""
                                font.family: Config.fontFamily
                                font.pixelSize: Config.fontSize - 2
                                color: Config.text
                                opacity: 0.55
                            }

                            Text {
                                text: "" // nf-fa-chevron-down
                                font.family: Config.fontFamily
                                font.pixelSize: Config.fontSize - 4
                                color: Config.text
                                opacity: 0.4
                                rotation: svc.expanded ? 180 : 0
                                Behavior on rotation {
                                    NumberAnimation {
                                        duration: 130
                                    }
                                }
                            }
                        }

                        // expanded detail: modelData.info key/values
                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.leftMargin: 19
                            spacing: 2
                            visible: svc.expanded
                            Repeater {
                                model: svc.expanded ? svc.modelData.info ?? [] : []
                                delegate: RowLayout {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    spacing: 12
                                    Text {
                                        Layout.fillWidth: true
                                        text: modelData.key
                                        elide: Text.ElideRight
                                        font.family: Config.fontFamily
                                        font.pixelSize: Config.fontSize - 3
                                        color: Config.text
                                        opacity: 0.45
                                    }
                                    Text {
                                        Layout.maximumWidth: svc.width * 0.45
                                        text: modelData.value
                                        horizontalAlignment: Text.AlignRight
                                        elide: Text.ElideRight
                                        font.family: Config.fontFamily
                                        font.pixelSize: Config.fontSize - 3
                                        color: Config.text
                                        opacity: 0.7
                                    }
                                }
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: svc.expanded = !svc.expanded
                    }
                }
            }

            // notification history view
            ListView {
                visible: Monitor.view === "notifications"
                onVisibleChanged: if (visible)
                    NotifHistory.load()
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 6
                model: visible ? NotifHistory.items : []

                delegate: Rectangle {
                    id: note
                    required property var modelData
                    width: ListView.view.width
                    implicitHeight: noteCol.implicitHeight + 16
                    radius: 6
                    color: Qt.rgba(1, 1, 1, 0.04)
                    border.width: 1
                    border.color: Config.border

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 8

                        // urgency dot: critical -> urgent, low -> dim, else good
                        Rectangle {
                            Layout.alignment: Qt.AlignTop
                            Layout.topMargin: 4
                            width: 9
                            height: 9
                            radius: 4.5
                            color: note.modelData.urgency === "critical" ? Config.urgent : Config.text
                            opacity: note.modelData.urgency === "low" ? 0.3 : 1
                        }

                        ColumnLayout {
                            id: noteCol
                            Layout.fillWidth: true
                            spacing: 2

                            RowLayout {
                                Layout.fillWidth: true
                                Text {
                                    Layout.fillWidth: true
                                    text: win.clean(note.modelData.app) || "?"
                                    elide: Text.ElideRight
                                    font.family: Config.fontFamily
                                    font.pixelSize: Config.fontSize - 2
                                    color: Config.primary
                                }
                                Text {
                                    text: win.notifTime(note.modelData.ts)
                                    font.family: Config.fontFamily
                                    font.pixelSize: Config.fontSize - 3
                                    color: Config.text
                                    opacity: 0.45
                                }
                            }

                            Text {
                                Layout.fillWidth: true
                                visible: !!text
                                text: win.clean(note.modelData.summary)
                                wrapMode: Text.Wrap
                                maximumLineCount: 2
                                elide: Text.ElideRight
                                font.family: Config.fontFamily
                                font.pixelSize: Config.fontSize
                                font.bold: true
                                color: Config.text
                            }

                            Text {
                                Layout.fillWidth: true
                                visible: !!text
                                text: win.clean(note.modelData.body)
                                wrapMode: Text.Wrap
                                maximumLineCount: 3
                                elide: Text.ElideRight
                                font.family: Config.fontFamily
                                font.pixelSize: Config.fontSize - 2
                                color: Config.text
                                opacity: 0.6
                            }
                        }
                    }
                }
            }
        }
    }
}
