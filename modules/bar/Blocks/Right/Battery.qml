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
    
    Timer {
        interval: 1000
        running: textItem.showTimeLeft
        repeat: true
        onTriggered: {
            if (textItem.showTimeLeft) {
                textItem.batteryTimeTillEmpty = UPower.displayDevice.timeToEmpty == 0 ? "charching" : "" + secondsToString(UPower.displayDevice.timeToEmpty)
            }
        }
    }

    function secondsToString(seconds){
        var hours = Math.floor(seconds / 3600);
        var minutes = Math.floor((seconds % 3600) / 60);

        return hours + "h " + minutes + "m " + "remaining";
    }

    Text {
        id: textItem
        property string batteryText: Math.round(UPower.displayDevice.percentage * 100)  + "%"
        property string batteryTimeTillEmpty: UPower.displayDevice.timeToEmpty == 0 ? "charching" : "" + secondsToString(UPower.displayDevice.timeToEmpty)
        property bool showTimeLeft: false
        text: showTimeLeft ? batteryTimeTillEmpty : batteryText
        anchors.centerIn: parent
        color: UPower.displayDevice.state != UPowerDeviceState.Discharging ? '#18d818' : "#ffffff"
        font {
            family: "JetBrainsMono Nerd Font Mono"
            pixelSize: 16
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: textItem.showTimeLeft = !textItem.showTimeLeft
        }
    }
}
