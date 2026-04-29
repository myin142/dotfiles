import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.ii.bar.notifications
import QtQuick
import Quickshell
import Quickshell.Wayland

Scope {
    Loader {
        id: notifLoader
        active: GlobalStates.notificationsBarOpen

        sourceComponent: PanelWindow {
            id: popupWindow
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            exclusiveZone: 0
            WlrLayershell.namespace: "quickshell:notificationsBarPopup"
            WlrLayershell.layer: WlrLayer.Overlay

            implicitWidth: popupBackground.implicitWidth + Appearance.sizes.elevationMargin * 2
            implicitHeight: popupBackground.implicitHeight + Appearance.sizes.elevationMargin * 2

            anchors {
                top: !Config.options.bar.bottom || Config.options.bar.vertical
                bottom: Config.options.bar.bottom && !Config.options.bar.vertical
                right: true
            }
            margins {
                top: Config.options.bar.vertical ? 0 : Appearance.sizes.barHeight
                bottom: Appearance.sizes.barHeight
                right: Appearance.rounding.screenRounding
            }

            mask: Region { item: popupBackground }

            Component.onCompleted: GlobalFocusGrab.addDismissable(popupWindow)
            Component.onDestruction: GlobalFocusGrab.removeDismissable(popupWindow)
            Connections {
                target: GlobalFocusGrab
                function onDismissed() {
                    GlobalStates.notificationsBarOpen = false;
                }
            }

            StyledRectangularShadow { target: popupBackground }

            Rectangle {
                id: popupBackground
                readonly property real padding: 14
                anchors {
                    fill: parent
                    leftMargin: Appearance.sizes.elevationMargin
                    rightMargin: Appearance.sizes.elevationMargin
                    topMargin: Appearance.sizes.elevationMargin
                    bottomMargin: Appearance.sizes.elevationMargin
                }
                implicitWidth: 320
                implicitHeight: 480
                color: Appearance.colors.colLayer0
                radius: Appearance.rounding.screenRounding - Appearance.sizes.hyprlandGapsOut + 1
                border.width: 1
                border.color: Appearance.colors.colLayer0Border

                NotificationList {
                    id: notificationList
                    anchors {
                        fill: parent
                        margins: popupBackground.padding
                    }
                }
            }
        }
    }
}
