import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "./../singletons/"

PanelWindow {
    id: root
    required property int barHeight
    property var modelData
    screen: modelData
    anchors {
        top: true
        left: true
    }

    property bool shouldBeVisible: PowerMenuHandler.powerMenu && PowerMenuHandler.screenName == root.screen.name
    property bool isVisible: false
    visible: finalVisibility || menu.height > 0
    implicitHeight: barHeight
    implicitWidth: 24 * 8
    exclusiveZone: barHeight
    color: "transparent"

    Connections {
        target: PowerMenuHandler
        function onPowerMenuChanged() { updateVisibility() }
        function onScreenNameChanged() { updateVisibility() }
    }

    Component.onCompleted: updateVisibility()

    function updateVisibility() {
        var shouldBeVisible = PowerMenuHandler.powerMenu && PowerMenuHandler.screenName == root.screen.name
        if (isVisible !== shouldBeVisible) {
            isVisible = shouldBeVisible
            if (!isVisible) {
                graceTimer.start()
            } else {
                finalVisibility = true
            }
        }
    }

    property bool finalVisibility: false

    Timer {
        id: graceTimer
        running: false
        repeat: false
        interval: 500
        onTriggered: {
            if (!menuMouseArea.containsMouse) {
                root.finalVisibility = false
            }
        }
    }

    Process { id: processHandler }

    // Define the menu model as a property for clarity
    property var menuModel: [
        { icon: "\udb81\udc25", cmd: ["systemctl", "poweroff"] },
        { icon: "\udb81\udf09", cmd: ["reboot"] },
        { icon: "\udb81\udcb2", cmd: ["systemctl", "suspend"] },
        { icon: "\udb80\udf41", cmd: ["hyprlock"] },
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
            spacing: 24
            Repeater {
                model: root.menuModel
                delegate: Text {
                    text: modelData.icon
                    color: "#ffffff"
                    font {
                        family: "JetBrainsMono Nerd Font Mono"
                        pixelSize: 28
                    }
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {

                            processHandler.exec(modelData.cmd)
                        }
                    }
                }
            }
        }
    }
}