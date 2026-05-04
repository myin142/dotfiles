import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
    id: root

    PanelWindow {
        id: osdWindow

        property bool osdVisible: false
        property var focusedMonitor: Brightness.monitors.find(m => m.screen.name === Hyprland.focusedMonitor?.name)
        property real currentBrightness: focusedMonitor?.brightness ?? 0

        visible: osdVisible
        screen: focusedMonitor?.screen ?? null

        WlrLayershell.namespace: "quickshell:brightnessOsd"
        WlrLayershell.layer: WlrLayer.Overlay
        exclusiveZone: 0

        anchors {
            top: true
            left: true
            right: true
        }

        margins.top: Appearance.sizes.barHeight
        implicitHeight: card.implicitHeight + Appearance.sizes.elevationMargin * 2

        color: "transparent"

        mask: Region {
            item: card
        }

        Connections {
            target: Brightness
            function onBrightnessChanged() {
                osdWindow.osdVisible = true;
                hideTimer.restart();
            }
        }

        Timer {
            id: hideTimer
            interval: 2000
            onTriggered: osdWindow.osdVisible = false
        }

        StyledRectangularShadow {
            target: card
        }

        Rectangle {
            id: card

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            implicitWidth: cardLayout.implicitWidth + 24 * 2
            implicitHeight: cardLayout.implicitHeight + 20 * 2
            color: Appearance.m3colors.m3surfaceContainer
            radius: Appearance.rounding.screenRounding

            opacity: osdWindow.osdVisible ? 1 : 0
            Behavior on opacity {
                NumberAnimation {
                    duration: Appearance.animation.elementMove.duration
                    easing.type: Appearance.animation.elementMove.type
                    easing.bezierCurve: Appearance.animation.elementMove.bezierCurve
                }
            }

            RowLayout {
                id: cardLayout
                anchors.centerIn: parent
                spacing: 12

                MaterialSymbol {
                    Layout.alignment: Qt.AlignVCenter
                    text: osdWindow.currentBrightness > 0.5 ? "brightness_high" : "brightness_low"
                    iconSize: Appearance.font.pixelSize.large
                    color: Appearance.m3colors.m3onSurface
                }

                StyledSlider {
                    Layout.alignment: Qt.AlignVCenter
                    implicitWidth: 240
                    from: 0
                    to: 1
                    value: osdWindow.currentBrightness
                    configuration: StyledSlider.Configuration.M
                }

                StyledText {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.minimumWidth: percentMetrics.width
                    text: `${Math.round(osdWindow.currentBrightness * 100)}%`
                    font.pixelSize: Appearance.font.pixelSize.normal
                    color: Appearance.m3colors.m3onSurface

                    TextMetrics {
                        id: percentMetrics
                        text: "100%"
                        font.pixelSize: Appearance.font.pixelSize.normal
                    }
                }
            }
        }
    }
}
