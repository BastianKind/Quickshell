import Quickshell
import QtQuick
import Quickshell.Services.SystemTray

Row {
    id: root
    required property var rootWindow
    anchors {
        top: parent.top
        bottom: parent.bottom
        right: parent.right
    }
    spacing: 16
    Volume {}
    Battery {}
    Time {}
    Tray {
        id: tray
        rootWindow: root.rootWindow
    }
}
