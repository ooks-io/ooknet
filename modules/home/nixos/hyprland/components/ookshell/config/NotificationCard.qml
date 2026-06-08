import QtQuick
import Quickshell

// ascii tmux-pane card (urgency-colored ╭─╮ border) wrapped in a hyprland-style
// window frame: neutral 2px border + sharp drop shadow (values from hyprland).
//   ┌ window frame (neutral) ─────────┐
//   │  ╭─ AppName ───────────╮        │
//   │  │ Summary             │        │
//   │  │ body...             │        │
//   │  ╰─────────────────────╯        │
//   └─────────────────────────────────┘
Item {
    id: card
    required property var notif

    readonly property int cols: Config.notifColumns
    readonly property int innerW: cols - 4 // text area between "│ " and " │"
    readonly property int pad: Config.notifPadding
    readonly property var g: Config.notifGlyphs
    readonly property var c: Config.notifColors
    readonly property var sh: Config.notifShadow

    // ascii border color carries urgency
    readonly property color borderColor: {
        const u = notif.urgency;
        const uc = c.urgency ?? ({});
        return u === 2 ? uc.critical : u === 0 ? uc.low : uc.normal;
    }

    readonly property int timeoutMs: {
        if (notif.expireTimeout > 0) return notif.expireTimeout;
        if (notif.expireTimeout === 0) return 0;
        const u = notif.urgency;
        return u === 2 ? Config.notifTimeoutCritical
            : u === 0 ? Config.notifTimeoutLow
            : Config.notifTimeoutNormal;
    }

    function rep(ch, n) {
        return n > 0 ? ch.repeat(n) : "";
    }
    function padEnd(s, n) {
        s = s.substring(0, n);
        return s + rep(" ", n - s.length);
    }
    function wrap(t, w) {
        const words = (t || "").trim().split(/\s+/).filter(x => x.length);
        const lines = [];
        let cur = "";
        for (let word of words) {
            while (word.length > w) {
                if (cur.length) {
                    lines.push(cur);
                    cur = "";
                }
                lines.push(word.substring(0, w));
                word = word.substring(w);
            }
            if (!cur.length) cur = word;
            else if (cur.length + 1 + word.length <= w) cur += " " + word;
            else {
                lines.push(cur);
                cur = word;
            }
        }
        if (cur.length) lines.push(cur);
        return lines;
    }

    readonly property string appLabel: {
        let a = (notif.appName || "notify").toLowerCase();
        const maxLen = cols - 6;
        return a.length > maxLen ? a.substring(0, maxLen) : a;
    }
    readonly property string topRight: " " + rep(g.horizontal, Math.max(0, cols - 5 - appLabel.length)) + g.topRight
    readonly property string bottomLine: g.bottomLeft + rep(g.horizontal, cols - 2) + g.bottomRight

    readonly property var bodyLines: {
        let lines = [];
        if (notif.summary && notif.summary.length) lines = lines.concat(wrap(notif.summary, innerW));
        if (notif.body && notif.body.length) lines = lines.concat(wrap(notif.body, innerW));
        const max = Config.notifMaxBodyLines;
        if (lines.length > max) {
            lines = lines.slice(0, max);
            lines[max - 1] = padEnd(lines[max - 1], innerW - 1) + "…";
        }
        if (!lines.length) lines = [""];
        return lines;
    }

    readonly property bool hasImage: (notif.image || "").length > 0

    // a notification is "editable" (click to open an editor) if it carries the
    // x-ookshell-edit hint, or falls back to a screenshot app with a file image
    readonly property string editPath: {
        if (notif.hints && notif.hints["x-ookshell-edit"])
            return String(notif.hints["x-ookshell-edit"]);
        if ((notif.appName || "").toLowerCase() === "screenshot") {
            const im = notif.image || "";
            if (im.startsWith("file://")) return im.substring(7);
        }
        return "";
    }
    readonly property bool editable: editPath.length > 0 && Config.notifImageEditor.length > 0

    readonly property var actions: notif.actions || []
    readonly property int actionsLen: {
        let n = 0;
        for (let i = 0; i < actions.length; i++)
            n += (i > 0 ? 1 : 0) + 4 + actions[i].text.length;
        return n;
    }

    component Mono: Text {
        font.family: Config.fontFamily
        font.pixelSize: Config.fontSize
        textFormat: Text.PlainText
    }

    implicitWidth: frame.width + (sh.enabled ? Math.max(0, sh.offsetX ?? 0) : 0)
    implicitHeight: frame.height + (sh.enabled ? Math.max(0, sh.offsetY ?? 0) : 0)

    // sharp drop shadow (solid offset rect, matches hyprland sharp shadow)
    Rectangle {
        visible: card.sh.enabled ?? false
        x: card.sh.offsetX ?? 0
        y: card.sh.offsetY ?? 0
        width: frame.width
        height: frame.height
        radius: frame.radius
        color: card.sh.color ?? "#000000"
    }

    // hyprland-style window frame (neutral border + bg)
    Rectangle {
        id: frame
        width: box.implicitWidth + card.pad * 2
        height: box.implicitHeight + card.pad * 2
        color: card.c.background
        radius: Config.notifRounding
        border.width: Config.notifBorderWidth
        border.color: Config.notifFrameBorder

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            cursorShape: card.editable ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: mouse => {
                if (mouse.button === Qt.RightButton) {
                    card.notif.dismiss();
                    return;
                }
                if (card.editable) {
                    Quickshell.execDetached(Config.notifImageEditor.concat([card.editPath]));
                    card.notif.dismiss();
                    return;
                }
                const def = card.actions.find(a => a.identifier === "default");
                if (def) def.invoke();
                card.notif.dismiss();
            }
        }

        // the ascii box, urgency-colored
        Column {
            id: box
            x: card.pad
            y: card.pad

            // top:  ╭─ AppName ───────╮
            Row {
                Mono {
                    color: card.borderColor
                    text: card.g.topLeft + card.g.horizontal + " "
                }
                Mono {
                    color: card.c.title
                    text: card.appLabel
                }
                Mono {
                    color: card.borderColor
                    text: card.topRight
                }
            }

            // body:  │ text │
            Repeater {
                model: card.bodyLines
                delegate: Row {
                    required property var modelData
                    visible: !card.hasImage
                    Mono {
                        color: card.borderColor
                        text: card.g.vertical + " "
                    }
                    Mono {
                        color: card.c.text
                        text: card.padEnd(modelData, card.innerW)
                    }
                    Mono {
                        color: card.borderColor
                        text: " " + card.g.vertical
                    }
                }
            }

            // image (screenshots, album art) spans the box width
            Image {
                id: shot
                visible: card.hasImage
                width: bottomBorder.implicitWidth
                height: implicitWidth > 0 ? width * implicitHeight / implicitWidth : 0
                source: card.hasImage ? card.notif.image : ""
                sourceSize.width: 700
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: true
            }

            // actions:  │ [ Reply ]      │
            Row {
                visible: !card.hasImage && card.actions.length > 0
                Mono {
                    color: card.borderColor
                    text: card.g.vertical + " "
                }
                Repeater {
                    model: card.actions
                    delegate: Mono {
                        required property var modelData
                        required property int index
                        color: card.c.action
                        text: (index > 0 ? " " : "") + "[ " + modelData.text + " ]"
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                modelData.invoke();
                                card.notif.dismiss();
                            }
                        }
                    }
                }
                Mono {
                    color: card.borderColor
                    text: card.rep(" ", Math.max(0, card.innerW - card.actionsLen)) + " " + card.g.vertical
                }
            }

            // bottom:  └──────────────┘
            Mono {
                id: bottomBorder
                color: card.borderColor
                text: card.bottomLine
            }
        }
    }

    HoverHandler {
        id: hover
    }

    Timer {
        interval: card.timeoutMs
        running: card.timeoutMs > 0 && !hover.hovered
        onTriggered: card.notif.expire()
    }
}
