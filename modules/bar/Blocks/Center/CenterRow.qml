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
        property MprisPlayer player: Mpris.players.values[0]
        text: player.trackTitle + " ~ " + player.trackArtist
        color: "white"
        font.pixelSize: 16
        font.family: "JetBrainsMono"
        anchors {
            verticalCenter: parent.verticalCenter
        }

        MouseArea {
            property MprisPlayer player: Mpris.players.values[0]
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: event => {
                if (event.button === Qt.LeftButton) {
                    player.togglePlaying();
                } else if (event.button === Qt.RightButton) {
                    player.next();
                } else if(event.button === Qt.MiddleButton){
                    player.previous()
                }
            }
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        }
    }
}
