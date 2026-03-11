import Quickshell
import QtQuick
import Quickshell.Services.Mpris
import qs.modules.singletons
import qs.modules.musicPopOut

Row {
    id: root
    required property string screenName
    function limitLength(text, length) {
        return ((text.length > length) ? text.slice(0, length) + "..." : text);
    }

    function getText(player) {
        if (player === null || player === undefined || player.playbackState == undefined) {
            return null;
        }
        var trackTitle = player.trackTitle ?? "Unknown Title";
        var trackArtist = player.trackArtist ?? "Unknown Artist";
        let text = limitLength(trackTitle == "" ? "Unknown Title" : trackTitle, 50) + limitLength(trackArtist == "" ? " ~ Unknown Artist" : trackArtist, 50);
        return text;
    }
    visible: Mpris.players.values.length > 0
    Text {
        id: playerText
        property var player: Mpris.players.values[Mpris.players.values.length - 1] ?? null
        text: root.getText(player) ?? ""
        color: "white"
        font.pixelSize: 16
        font.family: "JetBrainsMono Nerd Font Mono"
        height: 40
        verticalAlignment: Text.AlignVCenter

        MouseArea {
            id: mouseArea
            property var player: playerText.player
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: event => {
                if (event.button === Qt.LeftButton) {
                    player.togglePlaying();
                } else if (event.button === Qt.RightButton) {
                    player.next();
                } else if (event.button === Qt.MiddleButton) {
                    player.previous();
                }
            }
            onEntered: {
                FoldOutManager.setTriggerHovered("musicpopout", root.screenName, true);
                FoldOutManager.toggle("musicpopout", root.screenName, true);
            }
            onExited: {
                FoldOutManager.setTriggerHovered("musicpopout", root.screenName, false);
                musicPopOut.startGraceTimer();
            }
        }
    }
}
