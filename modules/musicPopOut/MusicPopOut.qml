import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import Quickshell.Hyprland
import qs.modules.singletons

PanelWindow {
    id: root
    required property int popOutHeight
    property var modelData
    property bool isVisible: false
    property bool finalVisibility: false

    screen: modelData
    anchors {
        top: true
        left: true
        right: true
    }
    visible: finalVisibility || popOut.height > 0
    implicitHeight: content.desiredHeight
    implicitWidth: getScreenWidth() / 3
    exclusiveZone: 0
    color: "transparent"
    
    Connections {
        target: MusicPopOutHandler
        function onShowMusicPopOutChanged() { updateVisibility() }
        function onScreenNameChanged() { updateVisibility() }
    }

    Process { id: processHandler }

    Component.onCompleted: updateVisibility()

    function updateVisibility() {
        var shouldBeVisible = MusicPopOutHandler.showMusicPopOut && MusicPopOutHandler.screenName == root.screen.name
        if (isVisible !== shouldBeVisible) {
            isVisible = shouldBeVisible
            if (!isVisible) {
                graceTimer.start()
            } else {
                finalVisibility = true
            }
        }
    }

    function getScreenWidth() {
        var screens = Quickshell.screens;
        for (var i = 0; i < screens.length; i++) {
            if (screens[i].name === root.screen.name) {
                return screens[i].width;
            }
        }
        return 0;
    }

    Timer {
        id: graceTimer
        running: false
        repeat: false
        interval: 500
        onTriggered: {
            root.finalVisibility = menuMouseArea.containsMouse ? true : (MusicPopOutHandler.showMusicPopOut && MusicPopOutHandler.screenName == root.screen.name)
        }
    }

    Rectangle{
        id: popOut
        y: 0
        x: getScreenWidth() / 3
        clip: true
        color: "#1a1a1a"
        height: root.finalVisibility ? content.desiredHeight : 0
        width: getScreenWidth() / 3
        bottomRightRadius: 16
        bottomLeftRadius: 16

        Behavior on height {
            NumberAnimation { duration: 250; easing.type: Easing.InOutCirc }
        }

        MouseArea {
            id: menuMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                graceTimer.restart()
                graceTimer.stop()
            }
            onExited: graceTimer.start()
        }
        PopOutContent{
            id: content
        }
    }
}
