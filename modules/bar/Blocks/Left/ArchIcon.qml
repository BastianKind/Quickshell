import Quickshell
import QtQuick
import qs.modules.singletons
import qs.modules.powerMenu

Rectangle {
    id: root

    anchors {
        verticalCenter: parent.verticalCenter
    }
    height: parent.height
    width: height * 0.8
    color: "transparent"
    required property string screenName

    Image {
        height: 24
        width: 24
        source: "../../icons/arch-linux-white.svg"
        anchors.centerIn: parent
        smooth: true
    }    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            FoldOutManager.toggle("powermenu", root.screenName, true)
        }
        onExited: {
            powerMenu.startTimer()
        }
    }
}