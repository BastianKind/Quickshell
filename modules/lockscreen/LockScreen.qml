pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick
import Fingerprint
import QtMultimedia

Scope {
    id: root
    property var wallpaperImage
    Component.onCompleted: {
        var sources = ["/home/david/Pictures/lock-screens/work/nms-1.png", "/home/david/Pictures/lock-screens/work/arch-clouds-trees.jpg", "/home/david/Pictures/lock-screens/work/retro-neon-utf-8.jpg", "/home/david/Pictures/lock-screens/work/super-simple-black.jpg", "/home/david/Pictures/lock-screens/work/default.jpg", "/home/david/Pictures/lock-screens/work/mountain-lake.jpg", "/home/david/Pictures/lock-screens/work/sundown-over-water.jpg", "/home/david/Pictures/lock-screens/work/interstellar-3.jpg", "/home/david/Pictures/lock-screens/work/wallhaven3.jpg", "/home/david/Pictures/lock-screens/work/Space-Nebula.jpg"];
        var id = Math.floor(Math.random() * sources.length);
        console.log(id);
        root.wallpaperImage = sources[id];
    }
    property var modelData
    GlobalShortcut {
        name: "lock"
        description: "test"

        onPressed: {
            lock.locked = true;
        }
    }
    FingerprintManager {
        id: fingerprint
        onVerificationSucceeded: {
            console.log("unlocking", fingerprint.status);
            lock.locked = false;
        }
        onStatusChanged: {
            console.log("new Status: ", fingerprint.status);
        }
        onVerifyingChanged: {
            if (!fingerprint.verifying && lock.secure) {
                fingerprint.startVerification();
            }
        }
    }
    WlSessionLock {
        id: lock

        WlSessionLockSurface {
            color: "#000000"

            Image {
                id: wallpaperElement
                anchors.fill: parent
                source: root.wallpaperImage
                fillMode: Image.PreserveAspectCrop
            }
            // Video {
            //     id: wallpaperElement
            //     anchors.fill: parent
            //     source: "file:///home/david/Videos/lockscreen/fractal-1.mp4"
            //     Component.onCompleted: {
            //         wallpaperElement.play();
            //     }
            // }
            ShaderEffectSource {
                id: bgTexture
                sourceItem: wallpaperElement
                hideSource: false
                live: true
            }
            ColumnLayout {
                anchors.fill: parent
                Item {
                    Layout.fillHeight: true
                    Layout.preferredHeight: 1
                }

                Time {
                    // anchors {
                    //     top: parent.top
                    // }
                    Layout.alignment: Qt.AlignHCenter
                    backgroundSource: bgTexture
                    wallpaper: wallpaperElement
                }

                Item {
                    Layout.fillHeight: true
                }

                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    width: 100
                    height: 100
                    color: "#BFB1FF"
                    radius: 250
                }

                Item {
                    Layout.fillHeight: true
                }

                // ColumnLayout {
                //     Layout.alignment: Qt.AlignHCenter
                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    width: 200
                    height: 200
                    color: "#9DFFAF"
                    radius: 250
                }
                InvertedText {
                    Layout.alignment: Qt.AlignHCenter
                    backgroundSource: bgTexture
                    wallpaper: wallpaperElement

                    horizontalAlignment: Text.AlignHCenter
                    pixelSize: 30
                    fontFamily: "JetBrainsMono Nerd Font Mono"

                    text: "Never gonna give you up\nRick Astley"
                }
                // }

                Item {
                    Layout.fillHeight: true
                }

                Button {
                    text: "unlock me"
                    Layout.alignment: Qt.AlignHCenter
                    onClicked: () => {
                        lock.locked = false;
                        fingerprint.stopVerification();
                    }
                }

                Item {
                    Layout.fillHeight: true
                }

                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    width: 100
                    height: 100
                    color: '#77a7ff'
                    radius: 250
                }
                Item {
                    Layout.fillHeight: true
                    Layout.preferredHeight: 1
                }
            }
        }
        onSecureStateChanged: {
            if (lock.secure) {
                fingerprint.startVerification();
                console.log("start verification");
            } else {
                fingerprint.stopVerification();
                console.log("stop verification");
            }
        }
    }
}
