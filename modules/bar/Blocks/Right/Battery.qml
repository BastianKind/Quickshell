import QtQuick
import QtCore
import Quickshell.Services.UPower

Rectangle {
    id: batteryDisplay
    color: "transparent"
    width: textItem.implicitWidth

    visible: UPower.onBattery || UPower.displayDevice.isLaptopBattery

    anchors {
        verticalCenter: parent.verticalCenter
        top: parent.top
        bottom: parent.bottom
    }
    

    Text {
        id: textItem
        text: Math.round(UPower.displayDevice.percentage * 100)  + "% =>"
        anchors.centerIn: parent
        color: UPower.displayDevice.state != UPowerDeviceState.Discharging ? '#18d818' : "#ffffff"
        font.pixelSize: 14
        font.family: "JetBrainsMono Nerd Font Mono"
    }
}
