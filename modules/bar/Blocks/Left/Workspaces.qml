import Quickshell.Hyprland
import QtQuick

Row {
    id: workspacesRow
    property string screenName: ""
    property var recInstances: []
    spacing: 8
    anchors {
        verticalCenter: parent.verticalCenter
    }

    Repeater {
        model: Hyprland.workspaces
        property var modelData

        Rectangle {
            visible: modelData.monitor.name === workspacesRow.screenName
            property string activeColor: "#4a9eff"
            property string inactiveColor: "#555555"

            id: rec
            width: 32
            height: 24
            radius: 15
            color: modelData.active ? activeColor : inactiveColor
            border.color: color
            border.width: 2

            Component.onCompleted: {
                workspacesRow.recInstances.push(rec)
            }

            MouseArea {
                property string oldColor: ""
                property string hoverColor: "#313131"
                property bool isActiveWorkspace: modelData.monitor.activeWorkspace.id === modelData.id
                hoverEnabled: !isActiveWorkspace
                anchors.fill: parent
                onClicked: {
                    if(!isActiveWorkspace){
                        Hyprland.dispatch("workspace " + modelData.id)
                        oldColor = parent.inactiveColor
                        parent.color = parent.activeColor
                        enabled = isActiveWorkspace
                    }
                }
                onIsActiveWorkspaceChanged: {
                    if(!isActiveWorkspace){
                        parent.color = parent.inactiveColor
                        oldColor = ""
                        enabled = !isActiveWorkspace
                    }
                    else {
                        parent.color = parent.activeColor
                        oldColor = ""
                        enabled = !isActiveWorkspace
                    }
                }
                onEntered: {
                    oldColor = parent.color
                    parent.color = hoverColor
                }
                onExited: {
                    parent.color = oldColor
                    oldColor = parent.inactiveColor
                }
            }

            Text {
                text: modelData.id
                anchors.centerIn: parent
                color: modelData.active ? "#ffffff" : "#cccccc"
                font.pixelSize: 12
                font.family: "Inter, sans-serif"
            }
        }
    }

    Text {
        visible: Hyprland.workspaces.length === 0
        text: "No workspaces"
        color: "#ffffff"
        font.pixelSize: 12
    }
}
