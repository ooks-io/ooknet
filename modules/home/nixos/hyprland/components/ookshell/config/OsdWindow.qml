import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: win
    visible: Osd.active
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay

    // top-centered (anchoring one edge centers on the other axis)
    anchors {
        top: true
    }
    margins {
        top: Config.osdMarginTop
    }

    implicitWidth: Math.max(1, slider.implicitWidth)
    implicitHeight: Math.max(1, slider.implicitHeight)
    exclusiveZone: 0

    OsdSlider {
        id: slider
    }
}
