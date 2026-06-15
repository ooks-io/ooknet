pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// runs `ooknet-monitor snapshot --config <services>`, parses the json, exposes
// machines + services + open state. polls in the background always so service
// down-alerts fire even when the pane is closed; notifies on status transitions.
Singleton {
    id: root

    property bool open: false
    property string view: "machines" // "machines" | "services" | "notifications"
    property var machines: []
    property var services: []
    property string generated: ""

    // aggregate health for the bar icon: "ok" | "warn" | "crit" (services only)
    readonly property string health: {
        var crit = false, warn = false;
        for (var i = 0; i < services.length; i++) {
            if (services[i].status === "down")
                crit = true;
            else if (services[i].status === "degraded")
                warn = true;
        }
        return crit ? "crit" : warn ? "warn" : "ok";
    }

    function show(v) {
        if (root.open && root.view === v)
            root.open = false; // same button while open -> close
        else {
            root.view = v;
            root.open = true;
        }
    }
    function toggle() {
        root.open = !root.open;
    }
    function refresh() {
        if (Config.monitorCmd && !proc.running)
            proc.running = true;
    }

    // previous service status, to notify only on change
    property var prevStatus: ({})
    function notifyTransitions(svcs) {
        var cur = {};
        for (var i = 0; i < svcs.length; i++) {
            const s = svcs[i];
            cur[s.name] = s.status;
            const prev = root.prevStatus[s.name];
            if (prev !== undefined && prev !== s.status) {
                if (s.status === "down")
                    Quickshell.execDetached([Config.notifyCmd, "-u", "critical", s.name + " is down", s.detail || ""]);
                else if (prev === "down")
                    Quickshell.execDetached([Config.notifyCmd, s.name + " recovered", s.detail || ""]);
            }
        }
        root.prevStatus = cur;
    }

    Process {
        id: proc
        command: Config.monitorConfig ? [Config.monitorCmd, "snapshot", "--config", Config.monitorConfig] : [Config.monitorCmd, "snapshot"]
        stdout: StdioCollector {
            id: collector
            onStreamFinished: {
                try {
                    const snap = JSON.parse(collector.text);
                    root.machines = snap.machines ?? [];
                    root.generated = snap.generated ?? "";
                    const svcs = snap.services ?? [];
                    root.notifyTransitions(svcs);
                    root.services = svcs;
                } catch (e) {
                    console.warn("[ookshell] monitor parse failed:", e);
                }
            }
        }
    }

    // background poll (always) + a quick refresh when the pane opens
    Timer {
        interval: 60000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }
    onOpenChanged: if (open)
        refresh()
}
