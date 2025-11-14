import Quickshell
import QtQuick
import Quickshell.Services.Mpris

Row {
    id: root
    anchors {
        top: parent.top
        bottom: parent.bottom
        centerIn: parent
    }
    Text {
        id: playerText
        property MprisPlayer player: Mpris.players.values[Mpris.players.values.length - 1]
        property string provText: player.trackTitle + " ~ " + player.trackArtist
        text: provText == " ~ " ? "" : provText
        color: "white"
        font.pixelSize: 16
        font.family: "JetBrainsMono Nerd Font Mono"
        height: 40
        verticalAlignment: Text.AlignVCenter

        MouseArea {
            property MprisPlayer player: Mpris.players.values[Mpris.players.values.length - 1]
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
