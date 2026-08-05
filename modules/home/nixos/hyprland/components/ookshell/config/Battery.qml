import QtQuick
import Quickshell.Services.UPower

// root is the click target; sizes to the text row. click opens the info popover
MouseArea {
    id: root

    readonly property var dev: UPower.displayDevice
    readonly property int pct: dev ? Math.round(dev.percentage * 100) : 0
    readonly property bool charging: dev
        ? (dev.state === UPowerDeviceState.Charging
            || dev.state === UPowerDeviceState.FullyCharged)
        : false

    readonly property var glyphs: [
        "\u{f007a}", "\u{f007b}", "\u{f007c}", "\u{f007d}", "\u{f007e}",
        "\u{f007f}", "\u{f0080}", "\u{f0081}", "\u{f0082}", "\u{f0079}"
    ]

    visible: dev && dev.isLaptopBattery && dev.isPresent
    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight

    onClicked: BatteryPopup.toggle()

    Text {
        id: label
        anchors.centerIn: parent
        font.family: Config.fontFamily
        font.pixelSize: Config.fontSize
        color: BatteryPopup.active ? Config.primary
            : root.pct <= 15 ? Config.batCrit
            : root.pct <= 35 ? Config.batWarn
            : Config.batGood
        text: (root.charging ? "\u{f140b} " : "")
            + root.glyphs[Math.min(9, Math.max(0, Math.floor(root.pct / 10)))]
            + " " + root.pct + "%"
    }
}
