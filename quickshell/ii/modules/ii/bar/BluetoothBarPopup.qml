import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.ii.bar.bluetooth
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Wayland

Scope {
    Loader {
        id: bluetoothLoader
        active: GlobalStates.bluetoothDialogOpen

        sourceComponent: PanelWindow {
            id: popupWindow
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            exclusiveZone: 0
            WlrLayershell.namespace: "quickshell:bluetoothBarPopup"
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
                    GlobalStates.bluetoothDialogOpen = false;
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
                implicitWidth: 350
                implicitHeight: 520
                color: Appearance.colors.colLayer0
                radius: Appearance.rounding.screenRounding - Appearance.sizes.hyprlandGapsOut + 1
                border.width: 1
                border.color: Appearance.colors.colLayer0Border

                ColumnLayout {
                    anchors {
                        fill: parent
                        margins: popupBackground.padding
                    }
                    spacing: 8

                    StyledText {
                        Layout.fillWidth: true
                        font.pixelSize: Appearance.font.pixelSize.larger
                        font.weight: Font.Medium
                        color: Appearance.colors.colOnSurface
                        text: Translation.tr("Bluetooth devices")
                    }

                    StyledIndeterminateProgressBar {
                        visible: Bluetooth.defaultAdapter?.discovering ?? false
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        visible: !(Bluetooth.defaultAdapter?.discovering ?? false)
                        Layout.fillWidth: true
                        implicitHeight: 1
                        color: Appearance.colors.colOutlineVariant
                    }

                    StyledListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        spacing: 0
                        animateAppearance: false

                        model: ScriptModel {
                            values: BluetoothStatus.friendlyDeviceList
                        }
                        delegate: BluetoothDeviceItem {
                            required property BluetoothDevice modelData
                            device: modelData
                            anchors {
                                left: parent?.left
                                right: parent?.right
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 1
                        color: Appearance.colors.colOutlineVariant
                    }

                    RowLayout {
                        Layout.fillWidth: true

                        DialogButton {
                            buttonText: Translation.tr("Details")
                            onClicked: {
                                Quickshell.execDetached(["bash", "-c", `${Config.options.apps.bluetooth}`]);
                                GlobalStates.bluetoothDialogOpen = false;
                            }
                        }

                        Item { Layout.fillWidth: true }

                        DialogButton {
                            buttonText: Translation.tr("Done")
                            onClicked: GlobalStates.bluetoothDialogOpen = false
                        }
                    }
                }
            }
        }
    }
}
