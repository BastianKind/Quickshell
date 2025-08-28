import QtQuick
import Quickshell
import QtQuick.Controls

Item {
    id: root
    property bool hovering: false
    width: 24
    height: 24

    required property var dock
    
    Image {
        id: archLogo
        source: "../icons/arch-linux-white.svg"
        anchors.verticalCenter: parent.verticalCenter
        width: 24
        height: 24
        smooth: true

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: dock.height = 40
            onExited: dock.height = 0
        }
    }
}