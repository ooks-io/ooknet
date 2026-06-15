pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

// pipewire audio service: tracks output/input devices + the default sink and
// exposes helpers to switch device / set volume / mute. powers the audio popover.
// switching the sink writes preferredDefaultAudioSink (the persistent wireplumber
// default), so volume keys -- which follow the default sink -- track it too
Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false

    readonly property real sourceVolume: source?.audio?.volume ?? 0
    readonly property bool sourceMuted: source?.audio?.muted ?? false

    property list<PwNode> sinks: []
    property list<PwNode> sources: []

    // pending re-route targets; applied by routeTimer shortly after the default
    // change (firing pw-metadata in the same tick races quickshell's own default
    // write and reverts the active sink -> the selection dot never updates)
    property var pendingSink: null
    property var pendingSource: null

    function setSink(node) {
        if (!node)
            return;
        Pipewire.preferredDefaultAudioSink = node;
        pendingSink = node;
        routeTimer.restart();
    }
    function setSource(node) {
        if (!node)
            return;
        Pipewire.preferredDefaultAudioSource = node;
        pendingSource = node;
        routeTimer.restart();
    }

    Timer {
        id: routeTimer
        interval: 400
        onTriggered: {
            if (root.pendingSink) {
                root.routeStreams("Stream/Output/Audio", root.pendingSink);
                root.pendingSink = null;
            }
            if (root.pendingSource) {
                root.routeStreams("Stream/Input/Audio", root.pendingSource);
                root.pendingSource = null;
            }
        }
    }

    // streams can be pinned to a device (target.object) and so ignore the default.
    // repoint every matching stream at the chosen node's serial so audio follows
    function routeStreams(mediaClass, target) {
        if (!target || !target.properties)
            return;
        const serial = target.properties["object.serial"];
        if (serial === undefined || serial === null)
            return;
        for (const n of Pipewire.nodes.values) {
            if (n.isStream && n.properties && n.properties["media.class"] === mediaClass)
                Quickshell.execDetached([Config.pwMetadata, "-n", "default", String(n.id), "target.object", String(serial), "Spa:Id"]);
        }
    }
    function setVolume(v) {
        if (sink?.ready && sink?.audio) {
            sink.audio.muted = false;
            sink.audio.volume = Math.max(0, Math.min(1, v));
        }
    }
    function changeVolume(delta) {
        setVolume(root.volume + delta);
    }
    function toggleMute() {
        if (sink?.ready && sink?.audio)
            sink.audio.muted = !sink.audio.muted;
    }

    function setSourceVolume(v) {
        if (source?.ready && source?.audio) {
            source.audio.muted = false;
            source.audio.volume = Math.max(0, Math.min(1, v));
        }
    }
    function changeSourceVolume(delta) {
        setSourceVolume(root.sourceVolume + delta);
    }
    function toggleSourceMute() {
        if (source?.ready && source?.audio)
            source.audio.muted = !source.audio.muted;
    }

    function label(node) {
        return node?.description || node?.name || "unknown";
    }

    function rebuild() {
        const outs = [];
        const ins = [];
        for (const n of Pipewire.nodes.values) {
            if (n.isStream)
                continue;
            if (n.isSink)
                outs.push(n);
            else if (n.audio)
                ins.push(n);
        }
        root.sinks = outs;
        root.sources = ins;
    }

    Component.onCompleted: rebuild()

    Connections {
        target: Pipewire.nodes
        function onValuesChanged() {
            root.rebuild();
        }
    }

    // track all nodes so device volume/muted stay live AND stream props
    // (media.class, object.serial) are populated for routeStreams
    PwObjectTracker {
        objects: Pipewire.nodes.values
    }
}
