pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Services.SystemTray

Row {
    id: root
    required property var rootWindow

    anchors {
        top: parent.top
        bottom: parent.bottom
    }
    Repeater {
        id: items

        model: SystemTray.items

        TrayItem {
            rootWindow: root.rootWindow
        }
    }
}
