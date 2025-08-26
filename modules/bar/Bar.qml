import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import "./blocks"

Scope {
    IpcHandler {
        target: "bar"
        id: ipcHandler

        function toggleVis(): void {
                for (let i = 0; i < Quickshell.screens.length; i++) {
                    barInstances[i].visible = !barInstances[i].visible;
            }
        }
    }
    property var barInstances: []

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: panel
            property var modelData
            screen: modelData   // attach to this screen
            color: "#00ffffff"
            anchors {
                top: true
                left: true
                right: true
            }

            Component.onCompleted: {
                barInstances.push(bar);
            }

            implicitHeight: 40

            margins {
                top: 5
                left: 5
                right: 5
                bottom: -10
            }

            Rectangle {
                id: bar
                anchors.fill: parent
                color:"#1a1a1a"
                radius: 16
                border.color: "#333333"
                border.width: 3

                Row {
                    id: workspacesRow

                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: 16
                    }
                    spacing: 8

                    Workspaces {
                        screenName: panel.screen.name
                    }

                    Text {
                        visible: Hyprland.workspaces.length === 0
                        text: "No workspaces"
                        color: "#ffffff"
                        font.pixelSize: 12
                    }
                }
                Row {
                    id: middleRow

                    anchors {
                        centerIn: parent
                        verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: "centered"
                        color: "#ffffff"
                    }
                }
                Time {
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        rightMargin: 16
                    }
                }
            }
        }
    }
}
