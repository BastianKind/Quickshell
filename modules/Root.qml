import QtQuick
import Quickshell
import "./bar/"
import "./powerMenu/"

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
        Bar {
            id: bar
            barHeight: root.barHeight
            modelData: root.modelData
        }
        PowerMenu {
            id: powerMenu
            barHeight: root.barHeight
            modelData: root.modelData
        }
    }
}
