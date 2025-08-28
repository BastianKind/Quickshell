import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Rectangle {
    id: dock
    property alias processHandler: processHandler
    property alias dockMouseArea: dockMouseArea

    height: dockMouseArea.containsMouse ? 40 : 0
    width: (24*4 + 16*6)
    bottomLeftRadius: 16
    bottomRightRadius: 16
    color: "#1a1a1a"
    border.color: "#333333"
    border.width: 0
    z: 100

    Behavior on height {
        NumberAnimation { duration: 100; easing.type: Easing.OutCurve }
    }

    MouseArea {
        id: dockMouseArea
        hoverEnabled: true
        anchors.fill: parent
    }

    Row {
        anchors.centerIn: parent
        visible: dock.height > 20
        spacing: 16
        property var iconHeight: 24
        property var iconWidth: 24 

        Process {
            id: processHandler
        }

        Rectangle {
            height: parent.iconHeight
            width: parent.iconWidth
            color: "transparent"
            Image {
                source: "../icons/i8-shutdown.png"
                anchors.fill: parent
                smooth: true
                anchors.verticalCenter: parent.verticalCenter
            }
            MouseArea {
                anchors.fill: parent
                onClicked: processHandler.exec(["systemctl","poweroff"])
                cursorShape: Qt.PointingHandCursor
            }
        }

        Rectangle {
            height: parent.iconHeight
            width: parent.iconWidth
            color: "transparent"
            Image {
                source: "../icons/i8-exit.png"
                anchors.fill: parent
                smooth: true
                anchors.verticalCenter: parent.verticalCenter
            }
            MouseArea {
                anchors.fill: parent
                onClicked: processHandler.exec(["hyprctl","dispatch","exit"])
                cursorShape: Qt.PointingHandCursor
            }
        }

        Rectangle {
            height: parent.iconHeight
            width: parent.iconWidth
            color: "transparent"
            Image {
                source: "../icons/i8-lock.svg"
                anchors.fill: parent
                smooth: true
                anchors.verticalCenter: parent.verticalCenter
            }
            MouseArea {
                anchors.fill: parent
                onClicked: processHandler.exec(["hyprlock"])
                cursorShape: Qt.PointingHandCursor
            }
        }

        Rectangle {
            height: parent.iconHeight
            width: parent.iconWidth
            color: "transparent"
            Image {
                source: "../icons/i8-restart.svg"
                anchors.fill: parent
                smooth: true
                anchors.verticalCenter: parent.verticalCenter
            }
            MouseArea {
                anchors.fill: parent
                onClicked: processHandler.exec(["reboot"])
                cursorShape: Qt.PointingHandCursor
            }
        }
    }
}
