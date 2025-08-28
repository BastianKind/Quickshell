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
            color: "#00ffffff"
            anchors {
                top: true
                left: true
                right: true
            }

            Component.onCompleted: {
                barInstances.push(bar);
            }

            implicitHeight: totalHeight

            property var totalHeight: bar.implicitHeight + dock.height

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
                    bottomLeftRadius: dock.height > 0 ? 0 : 16

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
                        // spacing: 16

                        // Text {
                        //     text: "centered"
                        //     color: "#ffffff"
                        // }
                        // Text {
                        //     text: "centered2"
                        //     color: "#ffffff"
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
                Rectangle {
                    id: dock
                    height: dockMouseArea.containsMouse ? 40 : 0
                    width: (24*4 + 16*6)
                    bottomLeftRadius: 16
                    bottomRightRadius: 16
                    color: "#1a1a1a"
                    border.color: "#333333"
                    border.width: 0
                    Behavior on height {
                        NumberAnimation { duration: 100; easing.type: Easing.OutCurve }
                    }
                    anchors {
                        left: parent.left
                        top: bar.bottom
                    }
                    MouseArea {
                        id: dockMouseArea
                        hoverEnabled: true
                        anchors.fill: parent
                    }

                    Row {
                        anchors.centerIn: parent
                        visible: dock.height > 20
                        spacing: 16
                        property var iconHeight: 24
                        property var iconWidth: 24 
                        
                        Process {
                            id: processHandler
                        }
                        
                        Rectangle {
                                height: parent.iconHeight
                                width: parent.iconWidth
                                color: "transparent"
                            Image {
                                source: "./icons/i8-shutdown.png"
                                anchors.fill: parent
                                smooth: true
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: processHandler.exec(["systemctl","poweroff"])
                                cursorShape: Qt.PointingHandCursor
                            }
                        }
                        Rectangle {
                                height: parent.iconHeight
                                width: parent.iconWidth
                                color: "transparent"
                            Image {
                                source: "./icons/i8-exit.png"
                                anchors.fill: parent
                                smooth: true
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: processHandler.exec(["hyprctl","dispatch", "exit"])
                                cursorShape: Qt.PointingHandCursor
                            }
                        }
                        Rectangle {
                                height: parent.iconHeight
                                width: parent.iconWidth
                                color: "transparent"
                            Image {
                                source: "./icons/i8-lock.svg"
                                anchors.fill: parent
                                smooth: true
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: processHandler.exec(["hyprlock"])
                                cursorShape: Qt.PointingHandCursor
                            }
                        }
                        Rectangle {
                                height: parent.iconHeight
                                width: parent.iconWidth
                                color: "transparent"
                            Image {
                                source: "./icons/i8-restart.svg"
                                anchors.fill: parent
                                smooth: true
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: processHandler.exec(["reboot"])
                                cursorShape: Qt.PointingHandCursor
                            }
                        }
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
