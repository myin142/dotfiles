import QtQuick 2.15
import QtQuick.Controls 2.15
import SddmComponents 2.0

Item {
    id: root
    width: Screen.width
    height: Screen.height

    // --- Configurable ---
    property color accentColor: "white"
    property color errorColor: "#ff6b6b"
    property color warnColor: "#f0c060"
    property string fontFamily: "monospace"
    property int timeFontSize: 60
    property int dateFontSize: 14
    property int inputWidth: 280

    // --- Background ---
    Background {
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
        onStatusChanged: {
            if (status === Image.Error)
                source = ""
        }
    }

    // --- Dark overlay for readability ---
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.4)
    }

    // --- Clock timer ---
    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            timeText.text = Qt.formatTime(new Date(), "HH:mm")
            dateText.text = Qt.formatDate(new Date(), "dddd, d MMMM yyyy")
        }
    }

    // --- Center column ---
    Column {
        anchors.centerIn: parent
        spacing: 8

        // Time
        Text {
            id: timeText
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatTime(new Date(), "HH:mm")
            font.family: root.fontFamily
            font.pixelSize: root.timeFontSize
            font.weight: Font.Thin
            color: root.accentColor
            renderType: Text.NativeRendering
        }

        // Date
        Text {
            id: dateText
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDate(new Date(), "dddd, d MMMM yyyy")
            font.family: root.fontFamily
            font.pixelSize: root.dateFontSize
            font.weight: Font.Light
            color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.7)
            renderType: Text.NativeRendering
        }

        // Spacer
        Item { width: 1; height: 48 }

        // Username
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: userModel.lastUser
            font.family: root.fontFamily
            font.pixelSize: 12
            font.weight: Font.Light
            color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.8)
            renderType: Text.NativeRendering
            font.letterSpacing: 2
        }

        // Spacer
        Item { width: 1; height: 8 }

        // Password field
        TextField {
            id: passwordField
            anchors.horizontalCenter: parent.horizontalCenter
            width: root.inputWidth
            echoMode: TextInput.Password
            placeholderText: "Password"
            placeholderTextColor: Qt.rgba(1, 1, 1, 0.2)
            color: root.accentColor
            font.family: root.fontFamily
            font.pixelSize: 12
            horizontalAlignment: TextInput.AlignHCenter
            leftPadding: 12
            rightPadding: 12
            topPadding: 8
            bottomPadding: 8
            selectionColor: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.3)

            background: Rectangle {
                color: Qt.rgba(0, 0, 0, 0.2)
                radius: 10
                border.color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.3)
                border.width: 1
            }

            Keys.onReturnPressed: {
                sddm.login(userModel.lastUser, passwordField.text, sessionModel.lastIndex)
            }

            onTextChanged: {
                errorText.visible = false
            }

            Component.onCompleted: forceActiveFocus()
        }

        // Caps Lock warning
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Caps Lock is on"
            font.family: root.fontFamily
            font.pixelSize: 12
            color: root.warnColor
            visible: keyboard.capsLock
            renderType: Text.NativeRendering
        }

        // Error message
        Text {
            id: errorText
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Incorrect password"
            font.family: root.fontFamily
            font.pixelSize: 12
            color: root.errorColor
            visible: false
            renderType: Text.NativeRendering
        }
    }

    // --- SDDM signals ---
    Connections {
        target: sddm
        onLoginFailed: {
            errorText.visible = true
            passwordField.clear()
            passwordField.forceActiveFocus()
        }
    }
}
