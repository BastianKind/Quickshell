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
    width: icon.width
    color: "Transparent"
    required property string screenName

    Image {
        id: icon
        height: 24
        width: 24
        source: "../../icons/arch-linux-white.svg"
        anchors.centerIn: parent
        smooth: true
    }
    MouseArea {
        anchors.fill: parent
        anchors.leftMargin: -16
        anchors.rightMargin: -16
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: {
            FoldOutManager.setTriggerHovered("powermenu", root.screenName, true);
        }
        onClicked: {
            FoldOutManager.toggle("powermenu", root.screenName, true);
        }
        onExited: {
            FoldOutManager.setTriggerHovered("powermenu", root.screenName, false);
            powerMenu.startTimer();
        }
    }
}
