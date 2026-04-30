pragma Singleton
pragma ComponentBehavior: Bound

import qs
import qs.modules.common
import qs.modules.common.functions
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    signal translationResult(string sourceText, string translatedText, string detectedSourceLang, string targetLang)
    signal translationError(string sourceText, string errorMessage)

    property bool loading: false
    property string sourceLang: Config.options.translator.sourceLang
    property string targetLang: Config.options.translator.targetLang

    property string apiKey: KeyringStorage.keyringData?.deepl?.apiKey ?? ""

    onSourceLangChanged: Config.setNestedValue("translator.sourceLang", root.sourceLang)
    onTargetLangChanged: Config.setNestedValue("translator.targetLang", root.targetLang)

    function setApiKey(key) {
        KeyringStorage.setNestedField(["deepl", "apiKey"], key);
    }

    function translate(text) {
        if (root.apiKey.length === 0) {
            root.translationError(text, "No API key set. Use /key <YOUR_DEEPL_API_KEY>");
            return;
        }
        if (root.targetLang.length === 0) {
            root.translationError(text, "No target language set. Use /target-lang <LANG_CODE>");
            return;
        }
        if (root.loading) return;

        translationProc.pendingText = text;
        let args = [
            "python3",
            `${Directories.scriptPath}/deepl/translate.py`,
            "--key", root.apiKey,
            "--text", text,
            "--target-lang", root.targetLang,
        ];
        if (root.sourceLang.length > 0) {
            args = args.concat(["--source-lang", root.sourceLang]);
        }
        translationProc.command = args;
        root.loading = true;
        translationProc.running = true;
    }

    Component.onCompleted: {
        loadKeyIfPossible();
    }

    function loadKeyIfPossible() {
        if (!KeyringStorage.loaded) {
            KeyringStorage.fetchKeyringData();
        }
    }

    Process {
        id: translationProc
        property string pendingText: ""

        stdout: StdioCollector {
            id: translationOutput
            onStreamFinished: {
                root.loading = false;
                if (text.trim().length === 0) return;
                try {
                    const parsed = JSON.parse(text);
                    if (parsed.error) {
                        root.translationError(translationProc.pendingText, parsed.error);
                        return;
                    }
                    const translation = parsed?.translations?.[0];
                    if (translation) {
                        root.translationResult(
                            translationProc.pendingText,
                            translation.text,
                            translation.detected_source_language ?? root.sourceLang,
                            root.targetLang
                        );
                    }
                } catch (e) {
                    root.translationError(translationProc.pendingText, `Parse error: ${e.message}`);
                }
            }
        }

        stderr: StdioCollector {
            id: translationError
            onStreamFinished: {
                root.loading = false;
                if (text.trim().length === 0) return;
                try {
                    const parsed = JSON.parse(text);
                    root.translationError(translationProc.pendingText, parsed.error ?? text);
                } catch (e) {
                    root.translationError(translationProc.pendingText, text.trim());
                }
            }
        }
    }
}
