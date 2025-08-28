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
    Text {
        anchors {
            verticalCenter: parent.verticalCenter
        }
        text: "left"
        color: "white"
        font.pixelSize: 16
        font.family: "JetBrainsMono"
    }
}
