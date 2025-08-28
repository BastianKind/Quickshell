import Quickshell
import QtQuick

Row {
    id: root
    anchors {
        top: parent.top
        bottom: parent.bottom
        centerIn: parent
    }
    Text {
        anchors {
            verticalCenter: parent.verticalCenter
        }
        text: "center"
        color: "white"
        font.pixelSize: 16
    }
}