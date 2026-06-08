import QtQuick

// ascii cells slider in the same hyprland-style window frame as notifications:
//   ╭─ Volume ─────────────────╮
//   │ ▮▮▮▮▮▮▮▮▮▯▯▯▯▯▯▯▯▯▯  62% │
//   ╰───────────────────────────╯
Item {
    id: osd

    readonly property int n: Config.osdCells
    readonly property int innerW: n + 5 // cells(n) + " " + 4-char value
    readonly property int cols: innerW + 4
    readonly property int pad: Config.osdPadding
    readonly property var g: Config.notifGlyphs // box drawing
    readonly property var cg: Config.osdGlyphs // cell glyphs
    readonly property var oc: Config.osdColors
    readonly property var sh: Config.frameShadow

    readonly property int filled: Osd.muted ? 0 : Math.max(0, Math.min(n, Math.round(Osd.value * n)))
    readonly property string valText: pad4(Osd.muted ? "mute" : Math.round(Osd.value * 100) + "%")
    readonly property color fillColor: oc.filled
    readonly property color emptyColor: Osd.muted ? oc.muted : oc.empty
    readonly property color valColor: Osd.muted ? oc.muted : oc.text

    function rep(ch, c) {
        return c > 0 ? ch.repeat(c) : "";
    }
    function pad4(s) {
        return rep(" ", Math.max(0, 4 - s.length)) + s;
    }

    readonly property string topRight: " " + rep(g.horizontal, Math.max(0, cols - 5 - Osd.kind.length)) + g.topRight
    readonly property string bottomLine: g.bottomLeft + rep(g.horizontal, cols - 2) + g.bottomRight

    component Mono: Text {
        font.family: Config.fontFamily
        font.pixelSize: Config.fontSize
        textFormat: Text.PlainText
    }

    implicitWidth: frame.width + (sh.enabled ? Math.max(0, sh.offsetX ?? 0) : 0)
    implicitHeight: frame.height + (sh.enabled ? Math.max(0, sh.offsetY ?? 0) : 0)

    Rectangle {
        visible: osd.sh.enabled ?? false
        x: osd.sh.offsetX ?? 0
        y: osd.sh.offsetY ?? 0
        width: frame.width
        height: frame.height
        radius: frame.radius
        color: osd.sh.color ?? "#000000"
    }

    Rectangle {
        id: frame
        width: box.implicitWidth + osd.pad * 2
        height: box.implicitHeight + osd.pad * 2
        color: Config.notifColors.background
        radius: Config.frameRounding
        border.width: Config.frameBorderWidth
        border.color: Config.frameBorder

        Column {
            id: box
            x: osd.pad
            y: osd.pad

            // top:  ╭─ Volume ─────╮
            Row {
                Mono {
                    color: osd.oc.border
                    text: osd.g.topLeft + osd.g.horizontal + " "
                }
                Mono {
                    color: osd.oc.title
                    text: Osd.kind.toLowerCase()
                }
                Mono {
                    color: osd.oc.border
                    text: osd.topRight
                }
            }

            // cells:  │ ▮▮▮▯▯▯  62% │
            Row {
                Mono {
                    color: osd.oc.border
                    text: osd.g.vertical + " "
                }
                Mono {
                    color: osd.fillColor
                    text: osd.rep(osd.cg.filled, osd.filled)
                }
                Mono {
                    color: osd.emptyColor
                    text: osd.rep(osd.cg.empty, osd.n - osd.filled)
                }
                Mono {
                    color: osd.valColor
                    text: " " + osd.valText
                }
                Mono {
                    color: osd.oc.border
                    text: " " + osd.g.vertical
                }
            }

            // bottom:  ╰──────────╯
            Mono {
                color: osd.oc.border
                text: osd.bottomLine
            }
        }
    }
}
