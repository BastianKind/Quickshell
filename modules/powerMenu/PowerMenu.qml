import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "./../singletons/"
import "./icons/"

PanelWindow {
    id: root
    required property int barHeight
    property var modelData
    screen: modelData
    anchors {
        top: true
        left: true
    }

    property bool isVisible: PowerMenuHandler.powerMenu && PowerMenuHandler.screenName == root.screen.name
    property bool finalVisibility: false
    visible: finalVisibility
    implicitHeight: barHeight
    implicitWidth: 24 * 6
    exclusiveZone: barHeight
    color: "transparent"

    onIsVisibleChanged: {
        if(isVisible == false){
            finalVisibility = true
            graceTimer.start()
        }else {
            finalVisibility = isVisible
        }
    }

    Timer {
        id: graceTimer
        running: false
        repeat: false
        interval: 500
        onTriggered: {
            if(!menuMouseArea.containsMouse){
                root.finalVisibility = root.isVisible
            }else {
                root.finalVisibility = true
            }
        }
    }

    Process {
        id: processHandler
    }

    Rectangle {
        y: root.barHeight
        color: "#1a1a1a"
        implicitHeight: root.barHeight
        bottomLeftRadius: 16
        bottomRightRadius: 16
        anchors.fill: parent
        MouseArea {
            id: menuMouseArea
            anchors.fill: parent
            hoverEnabled: true

            onExited: {
                graceTimer.start()
            }
        }
        Row {
            anchors.centerIn: parent
            spacing: 8
            Image {
                id: shutdown
                source: "./Icons/i8-shutdown.png"
                height: 24
                width: 24
                anchors.verticalCenter: parent.verticalCenter
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: processHandler.exec(["systemctl","poweroff"])
                }
            }
            Image {
                id: exit
                source: "./Icons/i8-exit.png"
                height: 24
                width: 24
                anchors.verticalCenter: parent.verticalCenter
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: processHandler.exec(["hyprctl","dispatch","exit"])
                }
            }
            Image {
                id: quit
                source: "./Icons/i8-lock.svg"
                height: 24
                width: 24
                anchors.verticalCenter: parent.verticalCenter
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: processHandler.exec(["hyprlock"])
                }
            }
            Image {
                id: reboot
                source: "./Icons/i8-restart.svg"
                height: 24
                width: 24
                anchors.verticalCenter: parent.verticalCenter
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: processHandler.exec(["reboot"])
                }
            }
            
        }
    }
}