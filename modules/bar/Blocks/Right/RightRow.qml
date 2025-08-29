import Quickshell
import QtQuick
import Quickshell.Services.SystemTray

Row {
    id: root
    anchors {
        top: parent.top
        bottom: parent.bottom
        right: parent.right
        rightMargin: 16
    }
    spacing: 16
    Volume {}
    Time {}
    Tray {}
}
