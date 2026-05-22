import Quickshell
import QtQuick
import QtQuick.Controls
import Quickshell.Services.Mpris
import Quickshell.Widgets
import QtQuick.Controls

Rectangle {
    id: root
    anchors.fill: parent
    color: "transparent"
    property var player: Mpris.players.values[Mpris.players.values.length - 1]
    property string trackArtUrl: player.trackArtUrl;
    property bool hasValidArt: trackArtUrl != "" && trackArtUrl != null && !trackArtUrl.toString().endsWith("AlbumCoverPlaceholder.svg") && albumArt.status === Image.Ready
    property real contentHeight: hasValidArt && albumArt.paintedHeight > 0 ? albumArt.paintedHeight + 32 : Math.min(albumArtBackground.width, 320) + 32
    property real desiredHeight: contentHeight + 32
    property bool artIsSquare: Math.abs(albumArt.paintedWidth - albumArt.paintedHeight) <= 4

    Connections {
        target: root.player ?? null
        function onTrackArtUrlChanged() {
            if(root.player.trackArtUrl.trim() != ""){
                root.trackArtUrl = root.player.trackArtUrl;
            } 
            albumArtBackground.rotation = 0
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

        ClippingRectangle {
            id: albumArtBackground
            anchors.centerIn: parent
            width: parent.width - 32
            height: root.contentHeight - 32
            clip: true
            color: "#222222"
            radius: root.artIsSquare ? 10000 : 8
            border.width: 2

            Image {
                id: albumArt
                anchors.centerIn: parent
                width: parent.width
                fillMode: Image.PreserveAspectFit
                rotation: 0;
                cache: false
                source: root.trackArtUrl && root.trackArtUrl != "" ? root.trackArtUrl : "../bar/icons/AlbumCoverPlaceholder.svg"
                sourceSize: Qt.size(320, 320)

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        player.raise();
                        albumArt.source = root.trackArtUrl && root.trackArtUrl != "" ? root.trackArtUrl : "../bar/icons/AlbumCoverPlaceholder.svg"
                        console.log("Opening player for " + albumArt.source)
                    }
                }

            }

            Rectangle {
                width: parent.width / 10
                height: parent.height / 10
                anchors.centerIn: parent
                color: '#1a1a1a'
                border.width: 2
                border.color: "black"
                radius: root.artIsSquare ? 10000 : 8
                visible: root.artIsSquare
            }

            RotationAnimation {
                id: spinAnim
                target: albumArtBackground
                from: albumArtBackground.rotation
                to: albumArtBackground.rotation + 360
                duration: 20000
                direction: RotationAnimation.Clockwise
                loops: Animation.Infinite
                running: (root.player?.isPlaying ?? false) && root.artIsSquare            
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

            Column {
                anchors {
                    fill: parent
                    margins: 16
                }
                spacing: 0

                // ── Track info ──────────────────────────────────────
                Item {
                    width: parent.width
                    height: root.player?.canSeek ?? false
                        ? spacerArea.height * 0.45
                        : spacerArea.height * 0.55

                    Behavior on height { NumberAnimation { duration: 200 } }

                    Column {
                        anchors.centerIn: parent
                        width: parent.width
                        spacing: 12

                        Text {
                            id: infoText
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "white"
                            width: parent.width
                            text: root.player ? (root.player.trackTitle === "" ? "Unknown Title" : root.player.trackTitle) : "Player unavailable"
                            horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.WordWrap
                            maximumLineCount: 2
                            elide: Text.ElideRight
                            font {
                                family: "JetBrainsMono Nerd Font Mono"
                                pixelSize: 20
                            }
                        }
                        Text {
                            id: infoText2
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "white"
                            text: root.player ? (root.player.trackArtist === "" ? "Unknown Artist" : root.player.trackArtist) : "unknown artist"
                            horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.WordWrap
                            maximumLineCount: 2
                            elide: Text.ElideRight
                            font {
                                family: "JetBrainsMono Nerd Font Mono"
                                pixelSize: 16
                            }
                        }
                    }
                }

                // ── Seek slider ─────────────────────────────────────
                Item {
                    width: parent.width
                    height: root.player?.canSeek ?? false ? 36 : 0
                    visible: height > 0
                    clip: true

                    Behavior on height { NumberAnimation { duration: 200 } }

                    Slider {
                        id: seekSlider
                        anchors {
                            left: parent.left
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                        }

                        from: 0
                        to: root.player?.length ?? 0

                        Binding {
                            target: seekSlider
                            property: "value"
                            value: root.player?.position ?? 0
                            when: !seekSlider.pressed
                        }

                        FrameAnimation {
                            running: root.player.playbackState == MprisPlaybackState.Playing
                            onTriggered: root.player.positionChanged()
                        }

                        onPressedChanged: {
                            // Seek on release, not on press
                            if (!pressed && root.player?.canSeek && root.player?.positionSupported) {
                                console.log("Seeking to " + seekSlider.value)
                                root.player.position = seekSlider.value
                            }
                        }
                    }
                }

                // ── Playback controls ───────────────────────────────
                Item {
                    width: parent.width
                    height: spacerArea.height - (parent.children[0].height + parent.children[1].height + parent.spacing * 2 + 32)

                    Row {
                        id: controlRow
                        anchors.centerIn: parent
                        spacing: parent.width / 8

                        Text {
                            text: "\udb83\udf28"
                            color: root.player === undefined ? "white" : (root.player.canGoPrevious ? "white" : "gray")
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            font { family: "JetBrainsMono Nerd Font Mono"; pixelSize: 32 }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: root.player?.canGoPrevious ? Qt.PointingHandCursor : Qt.ArrowCursor
                                onClicked: { if (root.player?.canGoPrevious) root.player.previous() }
                            }
                        }
                        Text {
                            text: root.player === undefined ? "\udb81\udc0d" : (root.player.isPlaying ? "\udb80\udfe6" : "\udb81\udc0d")
                            color: root.player?.canTogglePlaying ? "white" : "gray"
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            font { family: "JetBrainsMono Nerd Font Mono"; pixelSize: 80 }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: root.player?.canTogglePlaying ? Qt.PointingHandCursor : Qt.ArrowCursor
                                onClicked: { if (root.player?.canTogglePlaying) root.player.togglePlaying() }
                            }
                        }
                        Text {
                            text: "\udb83\udf27"
                            color: root.player === undefined ? "white" : (root.player.canGoNext ? "white" : "gray")
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            font { family: "JetBrainsMono Nerd Font Mono"; pixelSize: 32 }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: root.player?.canGoNext ? Qt.PointingHandCursor : Qt.ArrowCursor
                                onClicked: { if (root.player?.canGoNext) root.player.next() }
                            }
                        }
                    }
                }

                // ── other controls ─────────────────────────────
            }
        }
    }
}