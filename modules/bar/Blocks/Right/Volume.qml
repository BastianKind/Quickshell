import Quickshell.Services.Pipewire
import QtQuick
import Quickshell.Io

Text {
    id: root
    color: "#ffffff"
    font.pixelSize: 16
    font.family: "JetBrainsMono"

    anchors.verticalCenter: parent.verticalCenter
    property bool isReady: Pipewire.ready

    PwObjectTracker {
        id: tracker
        objects: [Pipewire.defaultAudioSink]
        Component.onCompleted: {
            root.isReady = Pipewire.ready
        }
    }
    text: Pipewire.defaultAudioSink.audio.volume.toFixed(2) * 100 + "%"

    onIsReadyChanged: {
        root.text = Pipewire.defaultAudioSink.audio.volume.toFixed(2) * 100 + "%"
    }

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
}
