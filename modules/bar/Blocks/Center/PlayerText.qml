import Quickshell
import QtQuick
import Quickshell.Services.Mpris

Row {
    id: root
    function getText(player){
        if(player === null || player === undefined){
            return ""
        }
        console.log(player.trackArtUrl)
        return player.trackTitle + " ~ " + player.trackArtist
    }

    Text {
        id: playerText
        property var player: Mpris.players.values[Mpris.players.values.length - 1]
        text: getText(player) ?? ""
        color: "white"
        font.pixelSize: 16
        font.family: "JetBrainsMono Nerd Font Mono"
        height: 40
        verticalAlignment: Text.AlignVCenter

        MouseArea {
            property var player: Mpris.players.values[Mpris.players.values.length - 1]
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: event => {
                if (event.button === Qt.LeftButton) {
                    player.togglePlaying();
                } else if (event.button === Qt.RightButton) {
                    player.next();
                } else if (event.button === Qt.MiddleButton) {
                    player.previous();
                }
            }
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        }
    }
}