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
    visible: finalVisibility || menu.height > 0
    implicitHeight: barHeight
    implicitWidth: 24 * 8
    exclusiveZone: barHeight
    color: "transparent"

    onIsVisibleChanged: {
        if (!isVisible) {
            finalVisibility = (PowerMenuHandler.screenName == root.screen.name)
            graceTimer.start()
        } else {
            finalVisibility = true
        }
    }

    Timer {
        id: graceTimer
        running: false
        repeat: false
        interval: 500
        onTriggered: {
            root.finalVisibility = menuMouseArea.containsMouse ? true : root.isVisible
        }
    }

    Process { id: processHandler }

    // Define the menu model as a property for clarity
    property var menuModel: [
        { icon: "./Icons/i8-shutdown.png", cmd: ["systemctl", "poweroff"] },
        { icon: "./Icons/i8-restart.svg", cmd: ["reboot"] },
        { icon: "./Icons/i8-sleep.png", cmd: ["systemctl", "suspend"] },
        { icon: "./Icons/i8-lock.svg", cmd: ["hyprlock"] },
    ]

    Rectangle {
        id: menu
        y: 0
        clip: true
        color: "#1a1a1a"
        height: root.finalVisibility ? root.barHeight : 0
        width: 24 * 8
        bottomRightRadius: 16

        Behavior on height {
            NumberAnimation { duration: 250; easing.type: Easing.InOutCirc }
        }

        MouseArea {
            id: menuMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onExited: graceTimer.start()
        }

        Row {
            anchors.centerIn: parent
            spacing: 18
            Repeater {
                model: root.menuModel
                delegate: Image {
                    source: modelData.icon
                    height: 24
                    width: 24
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: processHandler.exec(modelData.cmd)
                    }
                }
            }
        }
    }
}