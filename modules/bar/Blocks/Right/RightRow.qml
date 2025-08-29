import Quickshell
import QtQuick

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
}
