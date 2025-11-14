import Quickshell.Services.Pipewire
import QtQuick
import Quickshell.Io

Text {
    id: root
    function formatVolume(): string {
        Pipewire.defaultAudioSink.audio.volume = new Number(Pipewire.defaultAudioSink.audio.volume.toFixed(2)).valueOf();
        if(Pipewire.defaultAudioSink.audio.muted){
            return "󰝟"; 
        }
        else {
            return ((Pipewire.defaultAudioSink.audio.volume * 100).toFixed(0) + "%");
        }
    }
    Timer {
        running: true
        repeat: !Pipewire.ready
        interval: 25
        onTriggered: {
            root.text = root.formatVolume()
        }
    }

    color: "#ffffff"
    font.pixelSize: 16
    font.family: "JetBrainsMono Nerd Font Mono"

    anchors.verticalCenter: parent.verticalCenter
    property bool isReady: Pipewire.ready
    property bool isMuted: Pipewire.defaultAudioSink.audio.muted
    property var originVolume: Pipewire.defaultAudioSink.audio.volume

    property int amount: 1

    PwObjectTracker {
        id: tracker
        objects: [Pipewire.defaultAudioSink]
    }
    text: formatVolume()

    onIsReadyChanged: {
        root.text = root.formatVolume();
    }
    onIsMutedChanged: {
        root.text = root.formatVolume();
    }

    onOriginVolumeChanged: {
        root.text = root.formatVolume();
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
                Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted;
                root.text = root.formatVolume()
            }
        }
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        WheelHandler {
            orientation: Qt.Vertical
            property: "y"
            rotationScale: 15
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            onWheel: event => {
                if (event.angleDelta.y > 0) {
                    Pipewire.defaultAudioSink.audio.volume += root.amount / 100;
                } else {
                    Pipewire.defaultAudioSink.audio.volume -= root.amount / 100;
                }
                root.text = root.formatVolume();
            }
        }
    }
}
