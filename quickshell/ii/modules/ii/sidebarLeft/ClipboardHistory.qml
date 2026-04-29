import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property string searchText: searchField.text
    property var displayEntries: searchText.trim() === "" ? Cliphist.entries : Cliphist.fuzzyQuery(searchText)

    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        ToolbarTextField {
            id: searchField
            Layout.fillWidth: true
            Layout.fillHeight: false
            placeholderText: Translation.tr("Search clipboard...")
            colBackground: Appearance.colors.colLayer2
        }

        StyledListView {
            id: clipList
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: root.displayEntries
            spacing: 2
            clip: true

            delegate: Item {
                id: entryItem
                required property string modelData
                required property int index

                width: clipList.width
                height: contentRow.implicitHeight + 16

                Rectangle {
                    anchors.fill: parent
                    radius: Appearance.rounding.small
                    color: copyArea.containsMouse ? Appearance.colors.colLayer2 : "transparent"
                    Behavior on color {
                        ColorAnimation { duration: Appearance.animation.elementMoveFast.duration }
                    }
                }

                RowLayout {
                    id: contentRow
                    anchors {
                        left: parent.left
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        leftMargin: 10
                        rightMargin: 6
                    }
                    spacing: 6

                    Loader {
                        id: previewLoader
                        Layout.fillWidth: true
                        Layout.maximumHeight: 120
                        sourceComponent: Cliphist.entryIsImage(entryItem.modelData) ? imageComp : textComp

                        Component {
                            id: imageComp
                            CliphistImage {
                                entry: entryItem.modelData
                                maxWidth: clipList.width - 52
                                maxHeight: 120
                                blur: false
                            }
                        }

                        Component {
                            id: textComp
                            StyledText {
                                text: entryItem.modelData.replace(/^\d+\t/, "")
                                maximumLineCount: 2
                                elide: Text.ElideRight
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                color: Appearance.colors.colOnLayer1
                                font.pixelSize: Appearance.font.pixelSize.small
                            }
                        }
                    }

                    MaterialSymbol {
                        id: deleteIcon
                        text: "delete"
                        iconSize: Appearance.font.pixelSize.large
                        color: deleteArea.containsMouse ? Appearance.colors.colError : Appearance.colors.colSubtext
                        Behavior on color {
                            ColorAnimation { duration: Appearance.animation.elementMoveFast.duration }
                        }

                        MouseArea {
                            id: deleteArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Cliphist.deleteEntry(entryItem.modelData)
                        }
                    }
                }

                MouseArea {
                    id: copyArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    z: -1
                    onClicked: {
                        Cliphist.copy(entryItem.modelData)
                        GlobalStates.sidebarLeftOpen = false
                    }
                }
            }
        }

        Item {
            visible: root.displayEntries.length === 0
            Layout.fillWidth: true
            Layout.fillHeight: true

            StyledText {
                anchors.centerIn: parent
                text: root.searchText.trim() !== "" ? Translation.tr("No results") : Translation.tr("Clipboard is empty")
                color: Appearance.colors.colSubtext
            }
        }
    }
}
