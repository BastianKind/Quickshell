import QtQuick
import Quickshell
import "./bar/"

Variants {
    model: Quickshell.screens
    PanelWindow {
        id: root
        property var modelData
        readonly property int barHeight: 40
        screen: modelData   // attach to this screen
        color: "transparent"
        anchors {
            top: true
            left: true
            right: true
            bottom: true
        }
        mask: Region {
            x: 0
            y: 0
            width: root.modelData.width
            height: root.modelData.height
            intersection: Intersection.Xor
            regions: [
                Region {
                    x: 0
                    y: 0
                    width: root.modelData.width
                    height: root.modelData.height
                }
            ]
        }
        Rectangle {
            anchors.fill: parent
            anchors.margins: 0
            color: "transparent"
            border.width: 5
            border.color: "#333333"
        }
        Bar {
            id: bar
            barHeight: root.barHeight
            modelData: root.modelData
        }
    }
}