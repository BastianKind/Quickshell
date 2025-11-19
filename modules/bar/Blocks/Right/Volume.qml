import Quickshell.Services.Pipewire
import QtQuick
import Quickshell.Io

Row {
    id: root
    anchors {
        top: parent.top
        bottom: parent.bottom
    }
    spacing: 4
    
    Process {
        id: processHandler
    }

    function getVolume(){
        if(!Pipewire.ready){
            return 0;
        }
        if(Pipewire.defaultAudioSink.audio.muted){
            return 0; 
        }
        else {
            return ((Pipewire.defaultAudioSink.audio.volume * 100).toFixed(0));
        }
    }

    function formatVolume(): string {
        if(!Pipewire.ready){
            return "";
        }
        if(Pipewire.defaultAudioSink.audio.muted){
            return ""; 
        }
        else {
            return (getVolume() + "%");
        }
    }

    function getIcon(): string {
        if(!Pipewire.ready){
            return "";
        }
        if(Pipewire.defaultAudioSink.audio.muted){
            return "\udb81\udf5f";
        }
        switch(true){
            case (getVolume() >= 67):
                return "\udb81\udd7e";
            case (getVolume() >= 34):
                return "\udb81\udd80";
            case (getVolume() >= 1):
                return "\udb81\udd7f";
        }
        return "\udb83\ude08"
    }
    function getIconPixelSize(): int {
        if(!Pipewire.ready){
            return 0;
        }
        if(Pipewire.defaultAudioSink.audio.muted){
            return 26;
        }
        switch(true){
            case (getVolume() >= 67):
                return 22;
            case (getVolume() >= 34):
                return 18;
            case (getVolume() >= 1):
                return 14;
        }
        return 20;
    }
    Timer {
        running: true
        repeat: !Pipewire.ready
        interval: 25
        onTriggered: {
            textVolume.text = root.formatVolume()
        }
    }

    Text {
        id: textIcon
        text: getIcon()
        anchors.verticalCenter: parent.verticalCenter
        color: "#ffffff"
        font {
            family: "JetBrainsMono Nerd Font Mono"
            pixelSize: getIconPixelSize()
        }
        MouseArea {
            anchors.fill: parent
            onClicked: event => {
                if (event.button === Qt.LeftButton) {
                    processHandler.exec(["sh", "-c", "pavucontrol"]);
                } else if (event.button === Qt.RightButton) {
                    Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted;
                    textVolume.text = root.formatVolume();
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
                        Pipewire.defaultAudioSink.audio.volume += textVolume.amount / 100;
                    } else {
                        Pipewire.defaultAudioSink.audio.volume -= textVolume.amount / 100;
                    }
                    textVolume.text = root.formatVolume();
                }
            }
        }
    }
    Text {
        id: textVolume

        color: "#ffffff"
        font.pixelSize: 16
        font.family: "JetBrainsMono Nerd Font Mono"

        anchors.verticalCenter: parent.verticalCenter
        property bool isReady: Pipewire.ready
        property bool isMuted: isReady ? Pipewire.defaultAudioSink.audio.muted : false
        property var originVolume: isReady ? Pipewire.defaultAudioSink.audio.volume : 0.0

        property int amount: 1

        PwObjectTracker {
            id: tracker
            objects: [Pipewire.defaultAudioSink]
        }
        text: formatVolume()

        onIsReadyChanged: {
            textVolume.text = root.formatVolume();
        }
        onIsMutedChanged: {
            textVolume.text = root.formatVolume();
        }

        onOriginVolumeChanged: {
            textVolume.text = root.formatVolume();
        }
        MouseArea {
            anchors.fill: parent
            onClicked: event => {
                if (event.button === Qt.LeftButton) {
                    processHandler.exec(["sh", "-c", "pavucontrol"]);
                } else if (event.button === Qt.RightButton) {
                    Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted;
                    textVolume.text = root.formatVolume();
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
                        Pipewire.defaultAudioSink.audio.volume += textVolume.amount / 100;
                    } else {
                        Pipewire.defaultAudioSink.audio.volume -= textVolume.amount / 100;
                    }
                    textVolume.text = root.formatVolume();
                }
            }
        }
    }
}