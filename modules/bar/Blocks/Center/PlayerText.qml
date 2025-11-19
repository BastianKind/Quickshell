import Quickshell
import QtQuick
import Quickshell.Services.Mpris
import "../../../singletons"

Row {
    id: root
    required property string screenName
    function getText(player){
        if(player === null || player === undefined){
            return ""
        }
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
                MusicPopOutHandler.toggleMusicPopOut(root.screenName, true)
            }
            onExited: {
                MusicPopOutHandler.toggleMusicPopOut(root.screenName, false)
            }
        }
    }
}