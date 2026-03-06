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

    screen: modelData
    anchors {
        top: true
    }

    function startGraceTimer() {
        graceTimer.start()
    }
    
    property bool shouldBeVisible: {
        FoldOutManager.changeCounter
        return FoldOutManager.isOpen("musicpopout") && 
               FoldOutManager.getScreenName("musicpopout") === root.screen.name
    }
    
    property real targetHeight: 0
    
    onShouldBeVisibleChanged: {
        if (shouldBeVisible) {
            // Defer height calculation to next frame
            Qt.callLater(updateHeight)
        }
    }
    
    function updateHeight() {
        targetHeight = content.desiredHeight
    }
    
    visible: shouldBeVisible || popOut.height > 0 
    implicitHeight: shouldBeVisible ? targetHeight : 0
    implicitWidth: getScreenWidth() / 3
    exclusiveZone: 0
    color: "transparent"
    
    // Animate the window height
    Behavior on implicitHeight {
        NumberAnimation { 
            id: heightAnimation
            duration: 100
            easing.type: Easing.OutCubic
        }
    }

    Component.onCompleted: {
        FoldOutManager.registerFoldout("musicpopout")
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
            if (!menuMouseArea.containsMouse) {
                FoldOutManager.toggle("musicpopout", root.screen.name, false)
            }
        }
    }

    Rectangle{
        id: popOut
        anchors.fill: parent
        clip: true
        color: "#1a1a1a"
        bottomRightRadius: 16
        bottomLeftRadius: 16

        MouseArea {
            id: menuMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                graceTimer.stop()
                FoldOutManager.toggle("musicpopout", root.screen.name, true)
            }
            onExited: {
                graceTimer.start()
            }
        }
        
        PopOutContent{
            id: content
            anchors.top: parent.top
            opacity: root.shouldBeVisible ? 1.0 : 0.0
            visible: root.shouldBeVisible
        
            Behavior on opacity {
                NumberAnimation { duration: 150; easing.type: Easing.OutCubic; }
            }

            onDesiredHeightChanged: {
                if (root.shouldBeVisible) {
                    root.targetHeight = desiredHeight
                }
            }
        }
    }
}
