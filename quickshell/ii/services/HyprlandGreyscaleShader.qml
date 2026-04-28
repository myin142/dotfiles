pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

import qs.modules.common.models.hyprland

Singleton {
    id: root

    readonly property string shaderPath: Quickshell.shellPath("services/hyprlandGreyscaleShader/greyscale.glsl")
    property bool enabled: confOpt.value == shaderPath

    function enable() {
        HyprlandConfig.setMany({
            "decoration:screen_shader": root.shaderPath,
            "debug:damage_tracking": 1,
        });
    }

    function disable() {
        HyprlandConfig.resetMany([
            "decoration:screen_shader",
            "debug:damage_tracking"
        ]);
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
