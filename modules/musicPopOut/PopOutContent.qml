import Quickshell
import QtQuick
import QtQuick.Controls
import Quickshell.Services.Mpris

Rectangle {
    id: root
    anchors.fill: parent
    color: "transparent"
    property var player: Mpris.players.values[Mpris.players.values.length - 1]
    property string trackArtUrl: player ? player.trackArtUrl : ""
    property real desiredHeight: albumArt.status === Image.Ready ? Math.max(albumArt.paintedHeight * 1.4, 200) : 200

    Connections {
        target: player ?? null
        function onTrackArtUrlChanged() {
            albumArt.source = ""
            albumArt.source = player.trackArtUrl
        }
    }

    Rectangle {
        id: leftSide
        width: popOut.width / 2
        color: "transparent"
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
        }

        Rectangle {
            id: albumArtBackground
            anchors.centerIn: parent
            width: parent.width * 0.9
            height: albumArt.status === Image.Ready ? albumArt.paintedHeight + 32 : width
            color: "#222222"
            radius: 8

            Image {
                id: albumArt
                anchors.centerIn: parent
                width: parent.width * 0.9
                fillMode: Image.PreserveAspectFit
                cache: false
                source: player ? player.trackArtUrl : ""
            }
        }
    }
    Rectangle {
        id: rightSide
        width: popOut.width / 2
        color: "transparent"
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }

        Rectangle {
            id: spacerArea
            width: parent.width * 0.9
            height: albumArt.status === Image.Ready ? albumArt.paintedHeight + 32 : width
            anchors.centerIn: parent
            color: "#222222"
            radius: 8

            Rectangle{
                id: spacerTop
                height: parent.height / 5 * 3
                color: "transparent"
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }

                Column {
                    id: infoColumn
                    anchors.centerIn: parent
                    width: parent.width * 0.9
                    spacing: 12

                    Text {
                        id: infoText
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "white"
                        width: parent.width
                        text: player ? player.trackTitle : ""
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                        font {
                            family: "JetBrainsMono Nerd Font Mono"
                            pixelSize: 22
                        }
                    }
                    Text {
                        id: infoText2
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "white"
                        text: player ? player.trackArtist : ""
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                        font {
                            family: "JetBrainsMono Nerd Font Mono"
                            pixelSize: 14
                        }
                    }
                }
            }
            Rectangle{
                id: spacerBottom
                height: parent.height / 5 * 2
                width: parent.width * 0.9
                color: "transparent"
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }
                Row {
                    id: controlRow
                    anchors.centerIn: parent
                    spacing: 20

                    Text {
                        text: "\udb83\udf28"
                        color: player === undefined ? "white" : (player.canGoPrevious ? "white" : "gray")
                        anchors.verticalCenter: parent.verticalCenter
                        verticalAlignment: Text.AlignVCenter
                        font {
                            family: "JetBrainsMono Nerd Font Mono"
                            pixelSize: 32
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: player === undefined ? Qt.ArrowCursor : ( player.canGoPrevious ? Qt.PointingHandCursor : Qt.ArrowCursor)
                            onClicked: {
                                if(player && player.canGoPrevious){
                                    player.previous();
                                }
                            }
                        }
                    }
                    Text {
                        text: player === undefined ? "" : (player.isPlaying ? "\udb80\udfe6" : "\udb81\udc0d")
                        color: player === undefined ? "white" : (player.canTogglePlaying ? "white" : "gray")
                        anchors.verticalCenter: parent.verticalCenter
                        verticalAlignment: Text.AlignVCenter
                        font {
                            family: "JetBrainsMono Nerd Font Mono"
                            pixelSize: 64
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: player === undefined ? Qt.ArrowCursor : ( player.canTogglePlaying ? Qt.PointingHandCursor : Qt.ArrowCursor)
                            onClicked: {
                                if(player && player.canTogglePlaying){
                                    player.togglePlaying();
                                }
                            }
                        }
                    }
                    Text {
                        text: "\udb83\udf27"
                        color: player === undefined ? "white" : (player.canGoNext ? "white" : "gray")
                        anchors.verticalCenter: parent.verticalCenter
                        verticalAlignment: Text.AlignVCenter
                        font {
                            family: "JetBrainsMono Nerd Font Mono"
                            pixelSize: 32
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: player === undefined ? Qt.ArrowCursor : ( player.canGoNext ? Qt.PointingHandCursor : Qt.ArrowCursor)
                            onClicked: {
                                if(player && player.canGoNext){
                                    player.next();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}