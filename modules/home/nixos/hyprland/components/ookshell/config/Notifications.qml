pragma Singleton

import Quickshell
import Quickshell.Services.Notifications

// owns the org.freedesktop.Notifications dbus service (mako must be disabled)
Singleton {
    id: root

    readonly property alias list: server.trackedNotifications

    NotificationServer {
        id: server
        keepOnReload: true
        bodySupported: true
        bodyMarkupSupported: false // we render plain monospace, markup would break the ascii grid
        imageSupported: true // screenshots / album art etc.
        actionsSupported: true
        actionIconsSupported: false

        // notifications are discarded unless tracked
        onNotification: notification => notification.tracked = true
    }
}
