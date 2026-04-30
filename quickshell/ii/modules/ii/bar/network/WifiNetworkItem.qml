import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

DialogListItem {
    id: root
    required property var network
    property bool expanded: false
    pointingHandCursor: !expanded

    onClicked: expanded = !expanded
    altAction: () => expanded = !expanded

    function strengthSymbol(s) {
        return s > 83 ? "signal_wifi_4_bar"
            : s > 67 ? "network_wifi"
            : s > 50 ? "network_wifi_3_bar"
            : s > 33 ? "network_wifi_2_bar"
            : s > 17 ? "network_wifi_1_bar"
            : "signal_wifi_0_bar"
    }

    component ActionButton: DialogButton {
        colBackground: Appearance.colors.colPrimary
        colBackgroundHover: Appearance.colors.colPrimaryHover
        colRipple: Appearance.colors.colPrimaryActive
        colText: Appearance.colors.colOnPrimary
    }

    contentItem: ColumnLayout {
        anchors {
            fill: parent
            topMargin: root.verticalPadding
            leftMargin: root.horizontalPadding
            rightMargin: root.horizontalPadding
        }
        spacing: 0

        RowLayout {
            spacing: 10

            MaterialSymbol {
                iconSize: Appearance.font.pixelSize.larger
                text: root.strengthSymbol(root.network?.strength ?? 0)
                color: root.network?.active ? Appearance.colors.colPrimary : Appearance.colors.colOnSurfaceVariant
            }

            ColumnLayout {
                spacing: 2
                Layout.fillWidth: true

                RowLayout {
                    spacing: 4
                    Layout.fillWidth: true

                    StyledText {
                        Layout.fillWidth: true
                        color: root.network?.active ? Appearance.colors.colPrimary : Appearance.colors.colOnSurfaceVariant
                        elide: Text.ElideRight
                        text: root.network?.ssid || ""
                        textFormat: Text.PlainText
                        font.weight: root.network?.active ? Font.Medium : Font.Normal
                    }

                    MaterialSymbol {
                        visible: root.network?.isSecure ?? false
                        iconSize: Appearance.font.pixelSize.small
                        text: "lock"
                        color: Appearance.colors.colSubtext
                    }
                }

                StyledText {
                    visible: root.network?.active ?? false
                    font.pixelSize: Appearance.font.pixelSize.smaller
                    color: Appearance.colors.colPrimary
                    text: Network.wifiConnecting && Network.wifiConnectTarget === root.network
                        ? Translation.tr("Connecting…")
                        : Translation.tr("Connected")
                }
            }

            MaterialSymbol {
                text: "keyboard_arrow_down"
                iconSize: Appearance.font.pixelSize.larger
                color: Appearance.colors.colOnLayer3
                rotation: root.expanded ? 180 : 0
                Behavior on rotation {
                    animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
                }
            }
        }

        ColumnLayout {
            visible: root.expanded
            Layout.topMargin: 8
            spacing: 6

            RowLayout {
                visible: root.network?.askingPassword ?? false
                spacing: 6
                Layout.fillWidth: true

                MaterialTextField {
                    id: passwordField
                    Layout.fillWidth: true
                    placeholderText: Translation.tr("Password")
                    echoMode: TextInput.Password
                    Keys.onReturnPressed: submitPassword()
                }

                ActionButton {
                    buttonText: Translation.tr("Connect")
                    onClicked: submitPassword()
                }
            }

            RowLayout {
                visible: !(root.network?.askingPassword ?? false)
                Layout.fillWidth: true

                Item { Layout.fillWidth: true }

                ActionButton {
                    buttonText: root.network?.active ? Translation.tr("Disconnect") : Translation.tr("Connect")
                    onClicked: {
                        if (root.network?.active) {
                            Network.disconnectWifiNetwork();
                        } else {
                            Network.connectToWifiNetwork(root.network);
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }

    function submitPassword() {
        const pwd = passwordField.text;
        passwordField.text = "";
        Network.changePassword(root.network, pwd);
    }
}
