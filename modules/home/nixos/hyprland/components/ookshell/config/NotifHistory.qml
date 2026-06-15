pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// reads the appended notification log (~/.local/state/ookshell/notifications.jsonl)
// written by ooknotify-log, exposing the most recent entries newest-first.
Singleton {
    id: root

    property var items: [] // newest first
    readonly property int max: 200

    function load() {
        if (Config.notifLogPath)
            file.reload();
    }

    FileView {
        id: file
        path: Config.notifLogPath
        blockLoading: true
        onLoaded: {
            const lines = file.text().split("\n");
            const out = [];
            for (let i = lines.length - 1; i >= 0 && out.length < root.max; i--) {
                const ln = lines[i].trim();
                if (!ln)
                    continue;
                try {
                    out.push(JSON.parse(ln));
                } catch (e) {}
            }
            root.items = out;
        }
    }
}
