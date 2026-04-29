import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts

MouseArea {
    id: root

    required property bool isMic

    readonly property var audioNode: isMic ? Audio.source : Audio.sink
    readonly property real volume: audioNode?.audio?.volume ?? 0
    readonly property bool muted: audioNode?.audio?.muted ?? false

    clip: true
    implicitWidth: rowLayout.implicitWidth
    implicitHeight: Appearance.sizes.barHeight
    acceptedButtons: Qt.LeftButton
    hoverEnabled: true

    onWheel: event => {
        const vol = isMic ? (Audio.source?.audio?.volume ?? 0) : Audio.value;
        const step = vol < 0.1 ? 0.01 : 0.02;
        if (event.angleDelta.y > 0) {
            if (isMic)
                Audio.source.audio.volume = Math.min(1, Audio.source.audio.volume + step);
            else
                Audio.incrementVolume();
        } else if (event.angleDelta.y < 0) {
            if (isMic)
                Audio.source.audio.volume = Math.max(0, Audio.source.audio.volume - step);
            else
                Audio.decrementVolume();
        }
    }

    onClicked: {
        if (isMic)
            Audio.toggleMicMute();
        else
            Audio.toggleMute();
    }

    RowLayout {
        id: rowLayout
        spacing: 2
        anchors.verticalCenter: parent.verticalCenter

        ClippedFilledCircularProgress {
            id: audioCircProg
            Layout.alignment: Qt.AlignVCenter
            lineWidth: Appearance.rounding.unsharpen
            value: Math.min(1, root.volume)
            implicitSize: 20
            colPrimary: root.muted ? Appearance.colors.colError : Appearance.colors.colOnSecondaryContainer
            accountForLightBleeding: !root.muted
            enableAnimation: false

            Item {
                anchors.centerIn: parent
                width: audioCircProg.implicitSize
                height: audioCircProg.implicitSize

                MaterialSymbol {
                    anchors.centerIn: parent
                    font.weight: Font.DemiBold
                    fill: 1
                    text: root.isMic
                        ? (root.muted ? "mic_off" : "mic")
                        : (root.muted ? "volume_off" : "volume_up")
                    iconSize: Appearance.font.pixelSize.normal
                    color: Appearance.m3colors.m3onSecondaryContainer
                }
            }
        }

        Item {
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: fullVolumeTextMetrics.width
            implicitHeight: volumeText.implicitHeight

            TextMetrics {
                id: fullVolumeTextMetrics
                text: "100"
                font.pixelSize: Appearance.font.pixelSize.small
            }

            StyledText {
                id: volumeText
                anchors.centerIn: parent
                color: Appearance.colors.colOnLayer1
                font.pixelSize: Appearance.font.pixelSize.small
                text: `${Math.round(root.volume * 100)}`
            }
        }
    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: Appearance.animation.elementMove.duration
            easing.type: Appearance.animation.elementMove.type
            easing.bezierCurve: Appearance.animation.elementMove.bezierCurve
        }
    }
}
