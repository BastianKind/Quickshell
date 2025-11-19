import Quickshell
import QtQuick
import Quickshell.Services.Mpris

Row {
    id: root
    anchors {
        top: parent.top
        bottom: parent.bottom
        centerIn: parent
    }
    required property string screenName
    PlayerText{
        screenName: root.screenName
    }
}
