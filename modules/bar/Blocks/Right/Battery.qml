import QtQuick
import Quickshell.Services.UPower

Rectangle {
    id: batteryDisplay
    color: "transparent"

    visible: UPower.devices.length > 0 && UPower.devices[0].ready

    anchors {
        verticalCenter: parent.verticalCenter
        top: parent.top
        bottom: parent.bottom
    }

    width: 40

    Text {
        text: UPower.devices[0].percentage + "%"
        anchors.centerIn: parent
        color: "#ffffff"
        font.pixelSize: 12
        font.family: "Inter, sans-serif"
    }
}
