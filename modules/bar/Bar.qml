import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Widgets
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
        // function togglePowerMenu(): void {
        //     showPowerMenu = !showPowerMenu
        // }
    }
    property var barInstances: []
    property bool showPowerMenu: false
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: panel
            property var modelData
            screen: modelData   // attach to this screen
            color: "transparent"
            anchors {
                top: true
                left: true
                right: true
            }

            Component.onCompleted: {
                barInstances.push(bar);
            }

            property var totalHeight: bar.implicitHeight + dock.height

            onTotalHeightChanged: {
                panel.implicitHeight = totalHeight
            }

            margins {
                top: 5
                left: 5
                right: 5
                bottom: -10
            }
            Rectangle{
                id: barWrapper
                    anchors {
                        fill: parent
                    }
                color: "transparent"
                Rectangle {
                    id: bar
                    anchors {
                        top: parent.top
                        right: parent.right
                        left: parent.left
                    }
                    color:"#1a1a1a"
                    radius: 16
                    implicitHeight: 40
                    bottomLeftRadius: dock.height > 2 ? 0 : 16

                    Row {
                        id: workspacesRow

                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                            leftMargin: 16
                        }
                        spacing: 16
                        
                        ArchIcon {
                            dock: dock
                        }

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
                        spacing: 16

                        // Text {
                        //     text: "centered"
                        //     color: "#ffffff"
                        // }
                        // Text {
                        //     id: focusedAppText
                        //     color: "#ffffff"
                        //     font.pixelSize: 12
                        // }

                    }
                    Row {
                        id: endRow
                        
                        spacing: 16

                        anchors {
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                            rightMargin: 16
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
                Dock {
                    id: dock
                    anchors {
                        left: parent.left
                        top: bar.bottom
                    }
                }

                Rectangle {
                    id: barBorder
                    anchors.fill: bar
                    color: "transparent"
                    border.width: 3
                    border.color: "#333333"
                    radius: 16
                    z: 1
                }
            }
        }
    }
}
