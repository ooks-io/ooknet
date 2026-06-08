import QtQuick
import Quickshell.Services.UPower

Row {
    id: root
    spacing: 4

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

    Text {
        font.family: Config.fontFamily
        font.pixelSize: Config.fontSize
        color: root.pct <= 15 ? Config.batCrit
            : root.pct <= 35 ? Config.batWarn
            : Config.batGood
        text: (root.charging ? "\u{f140b} " : "")
            + root.glyphs[Math.min(9, Math.max(0, Math.floor(root.pct / 10)))]
            + " " + root.pct + "%"
    }
}
