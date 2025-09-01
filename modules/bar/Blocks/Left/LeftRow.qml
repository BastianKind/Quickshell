import Quickshell
import QtQuick

Row {
    id: root
    anchors {
        top: parent.top
        bottom: parent.bottom
        left: parent.left
        leftMargin: 16
    }
    required property string screenName
    spacing: 16
    ArchIcon {
        id: archIcon
        screenName: root.screenName
    }
    Workspaces {
        screenName: root.screenName
    }
}
