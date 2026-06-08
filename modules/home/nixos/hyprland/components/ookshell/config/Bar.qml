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

    // right cluster: record indicator + tray
    Row {
        anchors.right: parent.right
        anchors.rightMargin: Config.barSpacing
        anchors.verticalCenter: parent.verticalCenter
        spacing: Config.barSpacing

        HyprRecord {}
        Tray {}
    }
}
