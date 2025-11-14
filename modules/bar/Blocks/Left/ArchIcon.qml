import Quickshell
import QtQuick
import "../../../singletons"

Rectangle {
    id: root

    anchors {
        verticalCenter: parent.verticalCenter
    }
    height: 24
    width: 24
    color: "transparent"
    required property string screenName

    Image {
        height: 24
        width: 24
        source: "../../icons/arch-linux-white.svg"
        anchors.verticalCenter: parent.verticalCenter
        smooth: true
    }
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            PowerMenuHandler.togglePowerMenu(root.screenName, true)
        }
        onExited: {
            PowerMenuHandler.togglePowerMenu(root.screenName, false)
        }
    }
}