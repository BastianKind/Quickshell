import Quickshell
import QtQuick
import QtQuick.Layouts
import "./Blocks/Right"
import "./Blocks/Center"
import "./Blocks/Left"

PanelWindow {
    id: root
    required property int barHeight
    property var modelData
    screen: modelData
    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: barHeight
    exclusiveZone: barHeight
    color: "transparent"
    Rectangle {
        implicitHeight: root.barHeight 
        anchors.fill: parent
        color: "#1a1a1a"
        LeftRow {
            id: leftRow
            screenName: root.screen.name
        }

        CenterRow {
            id: centerRow
            screenName: root.screen.name
        }

        RightRow {
            id: rightRow
        }
    }
}