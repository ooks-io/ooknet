import QtQuick

Text {
    id: clock
    property bool showDate: false
    property var now: new Date()

    font.family: Config.fontFamily
    font.pixelSize: Config.fontSize
    color: Config.text
    text: showDate
        ? Qt.formatDateTime(now, "dd-MM-yyyy")
        : Qt.formatDateTime(now, "hh:mm AP")

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clock.now = new Date()
    }

    MouseArea {
        anchors.fill: parent
        onClicked: clock.showDate = !clock.showDate
    }
}
