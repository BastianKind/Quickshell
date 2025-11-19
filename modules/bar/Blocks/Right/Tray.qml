import QtQuick
import Quickshell.Services.SystemTray

Row{
    id: root
    anchors {
        top: parent.top
        bottom: parent.bottom
    }
    leftPadding: -8
    spacing: 16
    Repeater {
        id: items

        model: SystemTray.items

        TrayItem {}
    }
}
