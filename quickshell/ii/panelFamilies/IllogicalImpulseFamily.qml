import QtQuick
import Quickshell

import qs.modules.common
import qs.modules.ii.bar
import qs.modules.ii.cheatsheet
import qs.modules.ii.mediaControls
import qs.modules.ii.notificationPopup
import qs.modules.ii.polkit
import qs.modules.ii.regionSelector
import qs.modules.ii.screenCorners
import qs.modules.ii.sidebarLeft
import qs.modules.ii.overlay

Scope {
    PanelLoader { component: Bar {} }
    PanelLoader { component: Cheatsheet {} }
    PanelLoader { component: ClockWidgetPopup {} }
    PanelLoader { component: MediaControls {} }
    PanelLoader { component: NotificationBarPopup {} }
    PanelLoader { component: BluetoothBarPopup {} }
    PanelLoader { component: NotificationPopup {} }
    PanelLoader { component: Overlay {} }
    PanelLoader { component: Polkit {} }
    PanelLoader { component: RegionSelector {} }
    PanelLoader { component: ScreenCorners {} }
    PanelLoader { component: SidebarLeft {} }
}
