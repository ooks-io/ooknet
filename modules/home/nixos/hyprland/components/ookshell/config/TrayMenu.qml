pragma Singleton

import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland

// terminal-styled tray context menu rendered inside a full-screen layer-shell
// overlay (caelestia-style) instead of an XDG popup - the menu frame resizes
// within the fixed overlay, so submenu push/pop never reconfigures a popup
// surface (which flickered on hyprland). Backdrop click + hover-timeout dismiss.
Singleton {
    id: root

    property var menuHandle: null
    property real px: 0 // anchor: icon right edge (global x)
    property real py: 0 // anchor: icon bottom edge (global y)
    property bool active: false

    function openAt(handle, x, y) {
        root.menuHandle = handle;
        root.px = x;
        root.py = y;
        while (stack.depth > 1)
            stack.pop(StackView.Immediate);
        root.active = true;
    }

    function close() {
        root.active = false;
    }

    function entryLabel(e) {
        const t = (e.text || "").replace(/_/g, "");
        let prefix = "";
        if (e.buttonType === QsMenuButtonType.CheckBox)
            prefix = e.checkState === Qt.Checked ? "[x] " : "[ ] ";
        else if (e.buttonType === QsMenuButtonType.RadioButton)
            prefix = e.checkState === Qt.Checked ? "(o) " : "( ) ";
        return prefix + t + (e.hasChildren ? "  ›" : "");
    }

    PanelWindow {
        id: overlay
        visible: root.active
        color: "transparent"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "ookshell-traymenu"

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        exclusiveZone: 0

        // backdrop: a click anywhere outside the frame dismisses
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            onClicked: root.close()
        }

        Rectangle {
            id: frame
            // right-align to the icon, drop below it, clamp on screen
            x: Math.max(4, Math.min(root.px - width, overlay.width - width - 4))
            y: root.py
            color: Config.trayMenuBg
            radius: Config.frameRounding
            border.width: Config.frameBorderWidth
            border.color: Config.frameBorder
            width: stack.implicitWidth + Config.trayMenuPadding * 2
            height: stack.implicitHeight + Config.trayMenuPadding * 2
            clip: true

            // swallow clicks on the frame so they don't hit the backdrop
            MouseArea {
                anchors.fill: parent
            }

            HoverHandler {
                id: menuHover
            }

            Timer {
                interval: Config.trayMenuTimeout
                running: root.active && !menuHover.hovered
                onTriggered: root.close()
            }

            StackView {
                id: stack
                x: Config.trayMenuPadding
                y: Config.trayMenuPadding
                implicitWidth: currentItem ? currentItem.implicitWidth : 0
                implicitHeight: currentItem ? currentItem.implicitHeight : 0

                pushEnter: nullTransition
                pushExit: nullTransition
                popEnter: nullTransition
                popExit: nullTransition

                initialItem: SubMenu {
                    handle: root.menuHandle
                }
            }
        }
    }

    Transition {
        id: nullTransition
    }

    Component {
        id: subMenuComponent
        SubMenu {}
    }

    // one menu level
    component SubMenu: Column {
        id: sub
        property var handle: null
        property bool isSub: false

        StackView.onRemoved: destroy()

        QsMenuOpener {
            id: opener
            menu: sub.handle
        }

        MenuRow {
            visible: sub.isSub
            label: "‹ back"
            onTriggered: stack.pop()
        }
        Rectangle {
            visible: sub.isSub
            x: 2
            width: sub.width - 4
            height: 1
            color: Config.frameBorder
        }

        Repeater {
            model: opener.children
            delegate: MenuRow {
                required property var modelData
                entry: modelData
                label: modelData.isSeparator ? "" : root.entryLabel(modelData)
                separator: modelData.isSeparator
                enabledRow: modelData.enabled
                onTriggered: {
                    if (modelData.hasChildren)
                        stack.push(subMenuComponent.createObject(stack, {
                            handle: modelData,
                            isSub: true
                        }));
                    else {
                        modelData.triggered();
                        root.close();
                    }
                }
            }
        }
    }

    // content-width row; hover/click span the full menu width
    component MenuRow: Item {
        id: rowItem
        property var entry: null
        property string label: ""
        property bool separator: false
        property bool enabledRow: true
        signal triggered

        implicitWidth: separator ? 0 : rowText.implicitWidth + 8
        height: separator ? 7 : rowText.implicitHeight + 4

        Rectangle {
            width: rowItem.parent ? rowItem.parent.width : 0
            height: rowItem.height
            visible: rowHover.hovered && rowItem.enabledRow && !rowItem.separator
            color: Config.trayMenuHover
        }

        Rectangle {
            visible: rowItem.separator
            x: 2
            width: (rowItem.parent ? rowItem.parent.width : 4) - 4
            anchors.verticalCenter: parent.verticalCenter
            height: 1
            color: Config.frameBorder
        }

        Text {
            id: rowText
            visible: !rowItem.separator
            anchors.left: parent.left
            anchors.leftMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            font.family: Config.fontFamily
            font.pixelSize: Config.fontSize
            textFormat: Text.PlainText
            color: rowItem.enabledRow ? Config.trayMenuText : Config.trayMenuDisabled
            text: rowItem.label
        }

        HoverHandler {
            id: rowHover
            enabled: !rowItem.separator && rowItem.enabledRow
        }

        MouseArea {
            width: rowItem.parent ? rowItem.parent.width : 0
            height: rowItem.height
            enabled: !rowItem.separator && rowItem.enabledRow
            onClicked: rowItem.triggered()
        }
    }
}
