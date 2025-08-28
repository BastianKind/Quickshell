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
        text: player.trackTitle
        color: "white"
        font.pixelSize: 16
        font.family: "JetBrainsMono"

        MouseArea {
            property MprisPlayer player: Mpris.players.values[0]
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: event => {
                if (event.button === Qt.LeftButton) {
                    player.togglePlaying();
                } else if (event.button === Qt.RightButton) {
                    player.next();
                }
            }
            acceptedButtons: Qt.LeftButton | Qt.RightButton
        }
    }
}
