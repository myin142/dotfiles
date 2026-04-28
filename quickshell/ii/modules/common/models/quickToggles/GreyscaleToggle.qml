import QtQuick
import qs.services
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets

QuickToggleModel {
    name: Translation.tr("Greyscale")
    tooltipText: Translation.tr("Greyscale")
    icon: "filter_b_and_w"
    toggled: HyprlandGreyscaleShader.enabled

    mainAction: () => {
        HyprlandGreyscaleShader.toggle()
    }
}
