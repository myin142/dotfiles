import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // History area
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            StyledListView {
                id: historyList
                anchors.fill: parent
                model: historyModel
                spacing: 2
                clip: true
                verticalLayoutDirection: ListView.TopToBottom

                delegate: Item {
                    id: historyEntry
                    required property var modelData
                    required property int index
                    width: historyList.width
                    height: entryColumn.implicitHeight + 16

                    Rectangle {
                        anchors.fill: parent
                        radius: Appearance.rounding.small
                        color: historyEntry.modelData.isError
                            ? Qt.rgba(Appearance.m3colors.m3error.r, Appearance.m3colors.m3error.g, Appearance.m3colors.m3error.b, 0.10)
                            : "transparent"
                    }

                    ColumnLayout {
                        id: entryColumn
                        anchors {
                            left: parent.left
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                            leftMargin: 12
                            rightMargin: 12
                        }
                        spacing: 3

                        // Lang badge + source text row
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            visible: !historyEntry.modelData.isError

                            Rectangle {
                                radius: Appearance.rounding.full
                                color: Appearance.colors.colLayer2
                                implicitHeight: langBadgeText.implicitHeight + 4
                                implicitWidth: langBadgeText.implicitWidth + 10

                                StyledText {
                                    id: langBadgeText
                                    anchors.centerIn: parent
                                    text: `${historyEntry.modelData.sourceLang} → ${historyEntry.modelData.targetLang}`
                                    font.pixelSize: Appearance.font.pixelSize.tiny ?? (Appearance.font.pixelSize.smaller - 1)
                                    color: Appearance.colors.colSubtext
                                }
                            }

                            StyledText {
                                Layout.fillWidth: true
                                text: historyEntry.modelData.sourceText
                                font.pixelSize: Appearance.font.pixelSize.small
                                color: Appearance.colors.colSubtext
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                maximumLineCount: 2
                                elide: Text.ElideRight
                            }
                        }

                        // Translation / error text
                        StyledText {
                            Layout.fillWidth: true
                            text: historyEntry.modelData.isError
                                ? historyEntry.modelData.errorMessage
                                : historyEntry.modelData.translatedText
                            font.pixelSize: Appearance.font.pixelSize.normal
                            color: historyEntry.modelData.isError
                                ? Appearance.m3colors.m3error
                                : Appearance.colors.colOnLayer1
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        }
                    }
                }

                onCountChanged: {
                    Qt.callLater(() => historyList.positionViewAtEnd())
                }
            }

            // Empty state
            StyledText {
                anchors.centerIn: parent
                visible: historyModel.count === 0
                text: Translation.tr("No translations yet")
                color: Appearance.colors.colSubtext
            }
        }

        // Status bar
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: statusRow.implicitHeight + 8
            color: Appearance.colors.colLayer2

            RowLayout {
                id: statusRow
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    right: parent.right
                    leftMargin: 12
                    rightMargin: 12
                }
                spacing: 8

                MaterialSymbol {
                    text: DeepL.apiKey.length > 0 ? "key" : "key_off"
                    iconSize: Appearance.font.pixelSize.normal
                    color: DeepL.apiKey.length > 0 ? Appearance.m3colors.m3primary : Appearance.colors.colSubtext
                }

                StyledText {
                    text: {
                        const src = DeepL.sourceLang.length > 0 ? DeepL.sourceLang.toUpperCase() : "AUTO";
                        const tgt = DeepL.targetLang.length > 0 ? DeepL.targetLang.toUpperCase() : "?";
                        return `${src} → ${tgt}`;
                    }
                    font.pixelSize: Appearance.font.pixelSize.smaller
                    color: Appearance.colors.colSubtext
                }

                Item { Layout.fillWidth: true }

                // Loading indicator
                StyledText {
                    visible: DeepL.loading
                    text: Translation.tr("Translating…")
                    font.pixelSize: Appearance.font.pixelSize.smaller
                    color: Appearance.m3colors.m3primary

                    SequentialAnimation on opacity {
                        running: DeepL.loading
                        loops: Animation.Infinite
                        NumberAnimation { to: 0.3; duration: 600; easing.type: Easing.InOutSine }
                        NumberAnimation { to: 1.0; duration: 600; easing.type: Easing.InOutSine }
                    }
                }
            }
        }

        // Input field
        ToolbarTextField {
            id: inputField
            Layout.fillWidth: true
            Layout.fillHeight: false
            placeholderText: Translation.tr("/key <key>  /source <code>  /target <code>  /clear")
            colBackground: Appearance.colors.colLayer2

            Keys.onReturnPressed: (event) => {
                const raw = inputField.text.trim();
                if (raw.length === 0) return;

                const keyMatch = raw.match(/^\/key\s+(\S+)$/);
                const sourceLangMatch = raw.match(/^\/source\s+(\S+)$/);
                const targetLangMatch = raw.match(/^\/target\s+(\S+)$/);
                const clearMatch = raw.match(/^\/clear$/);

                if (clearMatch) {
                    historyModel.clear();
                } else if (keyMatch) {
                    DeepL.setApiKey(keyMatch[1]);
                    historyModel.append({
                        isError: false,
                        sourceText: "",
                        translatedText: Translation.tr("API key saved."),
                        translatedTextDisplay: Translation.tr("API key saved."),
                        sourceLang: "",
                        targetLang: "",
                        errorMessage: "",
                    });
                } else if (sourceLangMatch) {
                    DeepL.sourceLang = sourceLangMatch[1];
                    historyModel.append({
                        isError: false,
                        sourceText: "",
                        translatedText: Translation.tr("Source language set to: ") + sourceLangMatch[1].toUpperCase(),
                        translatedTextDisplay: Translation.tr("Source language set to: ") + sourceLangMatch[1].toUpperCase(),
                        sourceLang: "",
                        targetLang: "",
                        errorMessage: "",
                    });
                } else if (targetLangMatch) {
                    DeepL.targetLang = targetLangMatch[1];
                    historyModel.append({
                        isError: false,
                        sourceText: "",
                        translatedText: Translation.tr("Target language set to: ") + targetLangMatch[1].toUpperCase(),
                        translatedTextDisplay: Translation.tr("Target language set to: ") + targetLangMatch[1].toUpperCase(),
                        sourceLang: "",
                        targetLang: "",
                        errorMessage: "",
                    });
                } else if (!raw.startsWith("/")) {
                    DeepL.translate(raw);
                }

                inputField.text = "";
                event.accepted = true;
            }
        }
    }

    ListModel {
        id: historyModel
    }

    Connections {
        target: DeepL

        function onTranslationResult(sourceText, translatedText, detectedSourceLang, targetLang) {
            historyModel.append({
                isError: false,
                sourceText: sourceText,
                translatedText: translatedText,
                sourceLang: detectedSourceLang.toUpperCase(),
                targetLang: targetLang.toUpperCase(),
                errorMessage: "",
            });
        }

        function onTranslationError(sourceText, errorMessage) {
            historyModel.append({
                isError: true,
                sourceText: sourceText,
                translatedText: "",
                sourceLang: "",
                targetLang: "",
                errorMessage: errorMessage,
            });
        }
    }
}
