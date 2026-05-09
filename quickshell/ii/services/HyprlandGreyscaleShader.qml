pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland

import qs.modules.common.models.hyprland

Singleton {
    id: root

    readonly property string shaderPath: Quickshell.shellPath("services/hyprlandGreyscaleShader/greyscale.glsl")
    property bool enabled: false

    function enable() {
        enabled = true
        Quickshell.execDetached(["hyprctl", "keyword", "decoration:screen_shader", root.shaderPath]);
        Quickshell.execDetached(["hyprctl", "keyword", "debug:damage_tracking", "2"]);
    }

    function disable() {
        enabled = false
        Quickshell.execDetached(["hyprctl", "keyword", "decoration:screen_shader", ""]);
        Quickshell.execDetached(["hyprctl", "keyword", "debug:damage_tracking", "0"]);
    }

    function toggle() {
        if (root.enabled) disable()
        else enable()
    }

    HyprlandConfigOption {
        id: confOpt
        key: "decoration:screen_shader"
    }
}
