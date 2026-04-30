import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.ii.bar.network
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

Scope {
    Loader {
        id: networkLoader
        active: GlobalStates.networkDialogOpen

        sourceComponent: PanelWindow {
            id: popupWindow
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            exclusiveZone: 0
            WlrLayershell.namespace: "quickshell:networkBarPopup"
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
                    GlobalStates.networkDialogOpen = false;
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

                    Item {
                        Layout.fillWidth: true
                        implicitHeight: headerColumn.implicitHeight

                        StyledSwitch {
                            id: wifiToggle
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            checked: Network.wifiEnabled
                            onToggled: Network.toggleWifi()
                        }

                        ColumnLayout {
                            id: headerColumn
                            anchors {
                                left: parent.left
                                right: wifiToggle.left
                                rightMargin: 8
                                verticalCenter: parent.verticalCenter
                            }
                            spacing: 2

                            StyledText {
                                font.pixelSize: Appearance.font.pixelSize.larger
                                font.weight: Font.Medium
                                color: Appearance.colors.colOnSurface
                                text: Translation.tr("Wi-Fi")
                            }

                            Row {
                                spacing: 10
                                visible: Network.ethernetIpAddress !== "" || Network.wlanIpAddress !== ""

                                Row {
                                    visible: Network.ethernetIpAddress !== ""
                                    spacing: 4

                                    MaterialSymbol {
                                        text: "lan"
                                        iconSize: Appearance.font.pixelSize.small
                                        color: Appearance.colors.colSubtext
                                        anchors.verticalCenter: parent.verticalCenter
                                    }

                                    StyledText {
                                        font.pixelSize: Appearance.font.pixelSize.smaller
                                        color: Appearance.colors.colSubtext
                                        text: Network.ethernetIpAddress
                                        textFormat: Text.PlainText
                                    }
                                }

                                Row {
                                    visible: Network.wlanIpAddress !== ""
                                    spacing: 4

                                    MaterialSymbol {
                                        text: "wifi"
                                        iconSize: Appearance.font.pixelSize.small
                                        color: Appearance.colors.colSubtext
                                        anchors.verticalCenter: parent.verticalCenter
                                    }

                                    StyledText {
                                        font.pixelSize: Appearance.font.pixelSize.smaller
                                        color: Appearance.colors.colSubtext
                                        text: Network.wlanIpAddress
                                        textFormat: Text.PlainText
                                    }
                                }
                            }
                        }
                    }

                    StyledIndeterminateProgressBar {
                        visible: Network.wifiScanning
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        visible: !Network.wifiScanning
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
                        visible: Network.wifiEnabled

                        model: ScriptModel {
                            values: Network.friendlyWifiNetworks
                        }
                        delegate: WifiNetworkItem {
                            required property var modelData
                            network: modelData
                            anchors {
                                left: parent?.left
                                right: parent?.right
                            }
                        }
                    }

                    Item {
                        visible: !Network.wifiEnabled
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        StyledText {
                            anchors.centerIn: parent
                            color: Appearance.colors.colSubtext
                            text: Translation.tr("Wi-Fi is disabled")
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
                                Quickshell.execDetached(["bash", "-c", `${Config.options.apps.network}`]);
                                GlobalStates.networkDialogOpen = false;
                            }
                        }

                        Item { Layout.fillWidth: true }

                        DialogButton {
                            buttonText: Translation.tr("Rescan")
                            enabled: Network.wifiEnabled && !Network.wifiScanning
                            onClicked: Network.rescanWifi()
                        }

                        DialogButton {
                            buttonText: Translation.tr("Done")
                            onClicked: GlobalStates.networkDialogOpen = false
                        }
                    }
                }
            }
        }
    }
}
