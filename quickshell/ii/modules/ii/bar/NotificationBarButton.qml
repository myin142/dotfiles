import qs.modules.common
import qs.modules.common.widgets
import qs.services
import qs
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    implicitWidth: clickArea.implicitWidth
    implicitHeight: clickArea.implicitHeight

    MouseArea {
        id: clickArea
        anchors.fill: parent
        implicitWidth: notifIcon.implicitWidth
        implicitHeight: notifIcon.implicitHeight
        hoverEnabled: false

        onClicked: {
            GlobalStates.notificationsBarOpen = !GlobalStates.notificationsBarOpen;
            if (GlobalStates.notificationsBarOpen) {
                Notifications.timeoutAll();
                Notifications.markAllRead();
            }
        }

        NotificationUnreadCount {
            id: notifIcon
            anchors.centerIn: parent
        }
    }
}
