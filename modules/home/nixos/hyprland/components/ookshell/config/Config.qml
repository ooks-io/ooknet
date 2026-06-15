pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// reads the nix-generated config.json: layout settings + color scheme
Singleton {
    id: root

    property var data: ({})

    function reload() {
        try {
            root.data = JSON.parse(file.text());
        } catch (e) {
            console.warn("[ookshell] failed to parse config.json:", e);
        }
    }

    FileView {
        id: file
        path: Qt.resolvedUrl("config.json")
        blockLoading: true
        watchChanges: true
        onLoaded: root.reload()
        onFileChanged: reload()
    }

    Component.onCompleted: root.reload()

    readonly property var colors: data.colors ?? ({})
    readonly property var bar: data.bar ?? ({})

    // font
    readonly property string fontFamily: data.font ? data.font.family : "monospace"
    readonly property int fontSize: data.font ? data.font.size : 14

    // bar geometry
    readonly property int barHeight: bar.height ?? 32
    readonly property int barRadius: bar.radius ?? 10
    readonly property int barSpacing: bar.spacing ?? 12
    readonly property int barPadding: bar.padding ?? 12
    readonly property int barBorder: bar.borderWidth ?? 2
    readonly property int barExclusive: bar.exclusiveZone ?? 20
    readonly property int barMarginTop: bar.margin ? bar.margin.top : 10
    readonly property int barMarginLeft: bar.margin ? bar.margin.left : 10
    readonly property int barMarginRight: bar.margin ? bar.margin.right : 10

    // workspaces
    readonly property int wsPersistent: data.workspaces ? data.workspaces.persistent : 5
    readonly property int wsSpacing: data.workspaces ? data.workspaces.spacing : 8

    // tray
    readonly property int trayIconSize: data.tray ? data.tray.iconSize : 21
    readonly property int traySpacing: data.tray ? data.tray.spacing : 8
    readonly property bool trayCompact: data.tray ? (data.tray.compact ?? true) : true
    readonly property var trayMenu: data.tray ? (data.tray.menu ?? ({})) : ({})
    readonly property int trayMenuPadding: trayMenu.padding ?? 6
    readonly property int trayMenuTimeout: trayMenu.timeout ?? 1500
    readonly property var trayMenuColors: trayMenu.colors ?? ({})
    readonly property color trayMenuBg: trayMenuColors.background
    readonly property color trayMenuText: trayMenuColors.text
    readonly property color trayMenuDisabled: trayMenuColors.disabled
    readonly property color trayMenuHover: trayMenuColors.hover

    // notifications
    readonly property var notif: data.notifications ?? ({})
    readonly property string notifLogCmd: notif.logCmd ?? ""
    readonly property string notifLogPath: notif.logPath ?? ""
    readonly property int notifColumns: notif.columns ?? 38
    readonly property int notifPadding: notif.padding ?? 8
    readonly property int notifMaxBodyLines: notif.maxBodyLines ?? 4
    readonly property int notifMaxVisible: notif.maxVisible ?? 5
    readonly property int notifSpacing: notif.spacing ?? 8
    readonly property int notifMarginTop: notif.margin ? notif.margin.top : 10
    readonly property int notifMarginRight: notif.margin ? notif.margin.right : 10
    readonly property int notifTimeoutLow: notif.timeout ? notif.timeout.low : 3000
    readonly property int notifTimeoutNormal: notif.timeout ? notif.timeout.normal : 3000
    readonly property int notifTimeoutCritical: notif.timeout ? notif.timeout.critical : 0
    readonly property var notifGlyphs: notif.glyphs ?? ({})
    readonly property var notifColors: notif.colors ?? ({})
    readonly property var notifApps: notif.apps ?? ({})
    readonly property var notifImageEditor: notif.imageEditor ?? []
    readonly property var notifFrame: notif.frame ?? ({})
    readonly property var notifShadow: notifFrame.shadow ?? ({})
    readonly property int notifBorderWidth: notifFrame.borderWidth ?? 2
    readonly property int notifRounding: notifFrame.rounding ?? 0
    readonly property color notifFrameBorder: notifFrame.border

    // shared hyprland-style window frame (notifications + osd)
    readonly property var frame: data.frame ?? ({})
    readonly property var frameShadow: frame.shadow ?? ({})
    readonly property int frameBorderWidth: frame.borderWidth ?? 2
    readonly property int frameRounding: frame.rounding ?? 0
    readonly property color frameBorder: frame.border

    // osd
    readonly property var osd: data.osd ?? ({})
    readonly property int osdCells: osd.cells ?? 24
    readonly property int osdTimeout: osd.timeout ?? 1500
    readonly property int osdPadding: osd.padding ?? 8
    readonly property int osdMarginTop: osd.marginTop ?? 42
    readonly property var osdGlyphs: osd.glyphs ?? ({})
    readonly property var osdColors: osd.colors ?? ({})

    // audio
    readonly property var audioData: data.audio ?? ({})
    readonly property string pwMetadata: audioData.pwMetadata ?? "pw-metadata"

    // monitor / dashboard
    readonly property var monitorData: data.monitor ?? ({})
    readonly property string monitorCmd: monitorData.cmd ?? ""
    readonly property string monitorConfig: monitorData.config ?? ""
    readonly property string notifyCmd: monitorData.notifyCmd ?? "notify-send"
    readonly property int dashWidth: monitorData.width ?? 380
    readonly property int dashGap: monitorData.gap ?? 10

    // color roles, resolved in nix and read straight from config.json
    readonly property color bg: colors.background
    readonly property color text: colors.text
    readonly property color border: colors.border
    readonly property color primary: colors.workspaceActive
    readonly property color urgent: colors.workspaceUrgent
    readonly property color record: colors.record
    readonly property color batGood: colors.battery ? colors.battery.good : undefined
    readonly property color batWarn: colors.battery ? colors.battery.warning : undefined
    readonly property color batCrit: colors.battery ? colors.battery.critical : undefined
}
