import Quickshell.Services.Pipewire
import QtQuick
import Quickshell.Io

Text {
    color: "#ffffff"
    font.pixelSize: 16
    font.family: "JetBrainsMono"
    width: 50

    anchors.verticalCenter: parent.verticalCenter

    PwObjectTracker {
        id: tracker
        objects: [Pipewire.defaultAudioSink]
    }
    text: tracker.objects[0].audio.volume.toFixed(2) * 100 + "%"
    height: console.log(tracker.objects[0].description)

    Process {
        id: processHandler
    }

    MouseArea {
        anchors.fill: parent
        onClicked: event => {
            if (event.button === Qt.LeftButton) {
                processHandler.exec(["sh", "-c", "pavucontrol"]);
            } else if (event.button === Qt.RightButton) {
                tracker.objects[0].audio.muted = !tracker.objects[0].audio.muted;
            }
        }
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        WheelHandler {
            property: "rotation"
            onWheel: event => console.log("rotation", event.angleDelta.y, "scaled", rotation, "@", point.position, "=>", parent.rotation)
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            tracker.objects = [Pipewire.defaultAudioSink];
        }
    }
}
