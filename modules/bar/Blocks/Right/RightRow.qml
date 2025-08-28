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
    Text {
        anchors {
            verticalCenter: parent.verticalCenter
        }
        text: "right"
        color: "white"
        font.pixelSize: 16
    }
}