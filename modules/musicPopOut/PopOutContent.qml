import Quickshell
import QtQuick
import QtQuick.Controls
import Quickshell.Services.Mpris

Rectangle {
    id: root
    anchors.fill: parent
    color: "transparent"
    property var player: Mpris.players.values[Mpris.players.values.length - 1]
    property string trackArtUrl: player ? player.trackArtUrl : null
    property bool hasValidArt: trackArtUrl != "" && trackArtUrl != null && !trackArtUrl.toString().endsWith("AlbumCoverPlaceholder.svg") && albumArt.status === Image.Ready
    property real contentHeight: hasValidArt && albumArt.paintedHeight > 0 ? albumArt.paintedHeight + 32 : Math.min(albumArtBackground.width, 400) + 32
    property real desiredHeight: contentHeight + 32

    Connections {
        target: root.player ?? null
        function onTrackArtUrlChanged() {
            root.trackArtUrl = "";
            root.trackArtUrl = root.player.trackArtUrl;
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
            width: parent.width - 32
            height: root.contentHeight
            color: "#222222"
            radius: 8

            Image {
                id: albumArt
                anchors.centerIn: parent
                width: parent.width - 32
                fillMode: Image.PreserveAspectFit
                cache: false
                source: root.trackArtUrl && root.trackArtUrl != "" ? root.trackArtUrl : "../bar/icons/AlbumCoverPlaceholder.svg"
                sourceSize: Qt.size(512, 512)
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
            height: root.contentHeight
            anchors.centerIn: parent
            color: "#222222"
            radius: 8

            Rectangle {
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
                        text: root.player ? root.player.trackTitle : "unknown title"
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                        maximumLineCount: 2
                        elide: Text.ElideRight
                        font {
                            family: "JetBrainsMono Nerd Font Mono"
                            pixelSize: 22
                        }
                    }
                    Text {
                        id: infoText2
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "white"
                        text: root.player ? root.player.trackArtist : "unknown artist"
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                        maximumLineCount: 1
                        elide: Text.ElideRight
                        font {
                            family: "JetBrainsMono Nerd Font Mono"
                            pixelSize: 16
                        }
                    }
                }
            }
            Rectangle {
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
                    spacing: parent.width / 8

                    // Previous button
                    Text {
                        text: "\udb83\udf28"
                        color: root.player === undefined ? "white" : (root.player.canGoPrevious ? "white" : "gray")
                        anchors.verticalCenter: parent.verticalCenter
                        verticalAlignment: Text.AlignVCenter
                        font {
                            family: "JetBrainsMono Nerd Font Mono"
                            pixelSize: 32
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: root.player === undefined ? Qt.ArrowCursor : (root.player.canGoPrevious ? Qt.PointingHandCursor : Qt.ArrowCursor)
                            onClicked: {
                                if (root.player && root.player.canGoPrevious) {
                                    root.player.previous();
                                }
                            }
                        }
                    }
                    // Play/pause button
                    Text {
                        text: root.player === undefined ? "\udb81\udc0d" : (root.player.isPlaying ? "\udb80\udfe6" : "\udb81\udc0d")
                        color: root.player === undefined ? "white" : (root.player.canTogglePlaying ? "white" : "gray")
                        anchors.verticalCenter: parent.verticalCenter
                        verticalAlignment: Text.AlignVCenter
                        font {
                            family: "JetBrainsMono Nerd Font Mono"
                            pixelSize: 64
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: root.player === undefined ? Qt.ArrowCursor : (root.player.canTogglePlaying ? Qt.PointingHandCursor : Qt.ArrowCursor)
                            onClicked: {
                                if (root.player && root.player.canTogglePlaying) {
                                    root.player.togglePlaying();
                                }
                            }
                        }
                    }
                    // Next button
                    Text {
                        text: "\udb83\udf27"
                        color: root.player === undefined ? "white" : (root.player.canGoNext ? "white" : "gray")
                        anchors.verticalCenter: parent.verticalCenter
                        verticalAlignment: Text.AlignVCenter
                        font {
                            family: "JetBrainsMono Nerd Font Mono"
                            pixelSize: 32
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: root.player === undefined ? Qt.ArrowCursor : (root.player.canGoNext ? Qt.PointingHandCursor : Qt.ArrowCursor)
                            onClicked: {
                                if (root.player && root.player.canGoNext) {
                                    root.player.next();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
