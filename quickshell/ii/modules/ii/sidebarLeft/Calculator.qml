import qs.modules.common
import qs.modules.common
import qs.modules.common.widgets
import qs.services
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    property bool currencyLoading: false

    readonly property var currencyMap: ({
        "dollar": "USD", "dollars": "USD", "usd": "USD",
        "euro": "EUR", "euros": "EUR", "eur": "EUR",
        "yen": "JPY", "jpy": "JPY",
        "pound": "GBP", "pounds": "GBP", "gbp": "GBP", "sterling": "GBP",
        "yuan": "CNY", "cny": "CNY", "rmb": "CNY",
        "franc": "CHF", "francs": "CHF", "chf": "CHF",
        "won": "KRW", "krw": "KRW",
        "ruble": "RUB", "rubles": "RUB", "rub": "RUB",
        "rupee": "INR", "rupees": "INR", "inr": "INR",
        "peso": "MXN", "pesos": "MXN", "mxn": "MXN",
        "real": "BRL", "reais": "BRL", "brl": "BRL",
        "lira": "TRY", "try": "TRY",
        "krona": "SEK", "sek": "SEK",
        "krone": "NOK", "nok": "NOK",
        "dirham": "AED", "aed": "AED",
        "baht": "THB", "thb": "THB",
        "ringgit": "MYR", "myr": "MYR",
        "shekel": "ILS", "ils": "ILS",
        "zloty": "PLN", "pln": "PLN",
        "forint": "HUF", "huf": "HUF",
        "koruna": "CZK", "czk": "CZK",
        "dinar": "KWD", "kwd": "KWD",
        "cad": "CAD", "aud": "AUD", "nzd": "NZD",
        "sgd": "SGD", "hkd": "HKD",
    })

    function toCurrencyCode(name) {
        return currencyMap[name.toLowerCase()] ?? name.toUpperCase();
    }

    // Returns {amount, from, to} or null if not a currency expression
    function parseCurrency(raw) {
        const m = raw.match(/^([\d,.]+)\s*(\S+?)(?:\s+(?:to|in|->|→)\s+(\S+))?$/i);
        if (!m) return null;
        const amount = parseFloat(m[1].replace(/,/g, ""));
        if (isNaN(amount)) return null;
        const from = toCurrencyCode(m[2]);
        const to = m[3] ? toCurrencyCode(m[3]) : "EUR";
        // must look like a currency code (2-4 letters) or be in our map
        const knownFrom = currencyMap[m[2].toLowerCase()];
        const looksLikeCode = /^[A-Z]{2,4}$/.test(from);
        if (!knownFrom && !looksLikeCode) return null;
        return { amount, from, to };
    }

    function evaluate(expr) {
        const mathFns = ["abs","acos","acosh","asin","asinh","atan","atanh","atan2",
                         "cbrt","ceil","clz32","cos","cosh","exp","expm1","floor",
                         "fround","hypot","imul","log","log10","log1p","log2","max",
                         "min","pow","random","round","sign","sin","sinh","sqrt",
                         "tan","tanh","trunc"];
        let e = expr.replace(/π/g, "Math.PI").replace(/\^/g, "**");
        e = e.replace(/\b([a-zA-Z_]\w*)\b/g, (m) => mathFns.includes(m) ? "Math." + m : m);
        e = e.replace(/\bPI\b/g, "Math.PI");
        const stripped = e.replace(/Math\.\w+/g, "").replace(/Infinity|NaN/g, "");
        if (!/^[\d\s+\-*/%().eE,]*$/.test(stripped)) {
            throw new Error("Invalid expression");
        }
        const result = Function('"use strict"; return (' + e + ')')();
        if (typeof result !== "number") throw new Error("Not a number");
        if (!isFinite(result)) return String(result);
        if (Number.isInteger(result)) return String(result);
        return parseFloat(result.toPrecision(10)).toString();
    }

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

                        StyledText {
                            Layout.fillWidth: true
                            text: historyEntry.modelData.expression
                            font.pixelSize: Appearance.font.pixelSize.small
                            color: Appearance.colors.colSubtext
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        }

                        StyledText {
                            Layout.fillWidth: true
                            text: historyEntry.modelData.result
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

            StyledText {
                anchors.centerIn: parent
                visible: historyModel.count === 0
                text: Translation.tr("No calculations yet")
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
                    text: "calculate"
                    iconSize: Appearance.font.pixelSize.normal
                    color: Appearance.m3colors.m3primary
                }

                StyledText {
                    id: lastResultText
                    text: root.currencyLoading
                        ? Translation.tr("Converting…")
                        : (historyModel.count > 0 ? historyModel.get(historyModel.count - 1).result : Translation.tr("Ready"))
                    font.pixelSize: Appearance.font.pixelSize.smaller
                    color: Appearance.colors.colSubtext
                    elide: Text.ElideRight
                    Layout.fillWidth: true

                    SequentialAnimation on opacity {
                        running: root.currencyLoading
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
            placeholderText: Translation.tr("Expression or \"100 yen [to usd]\"  /clear")
            colBackground: Appearance.colors.colLayer2

            Keys.onReturnPressed: (event) => {
                const raw = inputField.text.trim();
                if (raw.length === 0) return;

                if (/^\/clear$/.test(raw)) {
                    historyModel.clear();
                } else {
                    const currency = root.parseCurrency(raw);
                    if (currency) {
                        currencyProc.pendingExpression = raw;
                        currencyProc.pendingFrom = currency.from;
                        currencyProc.pendingTo = currency.to;
                        currencyProc.command = [
                            "bash", "-c",
                            `curl -sf "https://api.frankfurter.dev/v1/latest?amount=${currency.amount}&from=${currency.from}&to=${currency.to}"`
                        ];
                        root.currencyLoading = true;
                        currencyProc.running = true;
                    } else {
                        try {
                            const result = root.evaluate(raw);
                            historyModel.append({
                                isError: false,
                                expression: raw,
                                result: "= " + result,
                            });
                        } catch (err) {
                            historyModel.append({
                                isError: true,
                                expression: raw,
                                result: err.message,
                            });
                        }
                    }
                }

                inputField.text = "";
                event.accepted = true;
            }
        }
    }

    ListModel {
        id: historyModel
    }

    Process {
        id: currencyProc
        property string pendingExpression: ""
        property string pendingFrom: ""
        property string pendingTo: ""

        stdout: StdioCollector {
            onStreamFinished: {
                root.currencyLoading = false;
                if (text.trim().length === 0) {
                    historyModel.append({ isError: true, expression: currencyProc.pendingExpression, result: "Network error" });
                    return;
                }
                try {
                    const data = JSON.parse(text);
                    const rate = data?.rates?.[currencyProc.pendingTo];
                    if (rate === undefined) {
                        historyModel.append({ isError: true, expression: currencyProc.pendingExpression, result: data?.message ?? "Unknown currency" });
                    } else {
                        const formatted = Number.isInteger(rate) ? String(rate) : parseFloat(rate.toPrecision(6)).toString();
                        historyModel.append({
                            isError: false,
                            expression: currencyProc.pendingExpression,
                            result: `= ${formatted} ${currencyProc.pendingTo}`,
                        });
                    }
                } catch (e) {
                    historyModel.append({ isError: true, expression: currencyProc.pendingExpression, result: "Parse error" });
                }
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {
                if (text.trim().length === 0) return;
                root.currencyLoading = false;
                historyModel.append({ isError: true, expression: currencyProc.pendingExpression, result: text.trim() });
            }
        }
    }
}
