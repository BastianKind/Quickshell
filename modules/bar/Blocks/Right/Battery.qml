import QtQuick
import QtCore
import Quickshell.Services.UPower

Rectangle {
    id: batteryDisplay
    color: "transparent"
    width: textItem.implicitWidth

    visible: UPower.onBattery || UPower.displayDevice.isLaptopBattery

    anchors {
        top: parent.top
        bottom: parent.bottom
    }
    
    function secondsToString(seconds){
        var hours = Math.floor(seconds / 3600);
        var minutes = Math.floor((seconds % 3600) / 60);

        return hours + "h " + minutes + "m " + "remaining";
    }

    function getIcon(){
        if(UPower.displayDevice.state != UPowerDeviceState.Discharging ){
            switch (true){
                case getPercantage() >=70:
                    return "\udb84\udea6";
                case getPercantage() >=40:
                    return "\udb84\udea5";
                case getPercantage() >=10:
                    return "\udb84\udea4";
                case getPercantage() <10:
                    return "\udb82\udc9f";
            }
        }
        else {
            switch (true){
                case getPercantage() >=70:
                    return "\udb84\udea3";
                case getPercantage() >=40:
                    return "\udb84\udea2";
                case getPercantage() >=10:
                    return "\udb84\udea1";
                case getPercantage() <10:
                    return "\udb80\udc8e";
            }
        }
        return "\udb84\ude5e"
    }

    function getPercantage(){
        return Math.round(UPower.displayDevice.percentage * 100)
    }

    Connections {
        target: UPower.displayDevice
        function onStateChanged() {
            textItem.batteryTimeTillEmpty = UPower.displayDevice.timeToEmpty == 0 ? "charging" : "" + secondsToString(UPower.displayDevice.timeToEmpty)
        }
        function onTimeToEmptyChanged() {
            if (textItem.showTimeLeft) {
                textItem.batteryTimeTillEmpty = UPower.displayDevice.timeToEmpty == 0 ? "charging" : "" + secondsToString(UPower.displayDevice.timeToEmpty)
            }
        }
    }

    Timer {
        id: updateTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            textItem.batteryTimeTillEmpty = UPower.displayDevice.timeToEmpty == 0 ? "charging" : "" + secondsToString(UPower.displayDevice.timeToEmpty)
        }
    }
    Row{
        anchors.centerIn: parent
        spacing: UPower.displayDevice.state != UPowerDeviceState.Discharging ? 4 : 6
        property string color: UPower.displayDevice.state != UPowerDeviceState.Discharging ? '#18d818' : getPercantage() >= 10 ? "#ffffff" : "#ff0000";
        Text {
            id: textIcon
            anchors.verticalCenter: parent.verticalCenter
            color: parent.color;
            font {
                family: "JetBrainsMono Nerd Font Mono"
                pixelSize: UPower.displayDevice.state != UPowerDeviceState.Discharging ? 28 : 16
            }
            text: getIcon()
        }

        Text {
            id: textItem
            property string batteryText: getPercantage()  + "%"
            property string batteryTimeTillEmpty: UPower.displayDevice.timeToEmpty == 0 ? "charging" : "" + secondsToString(UPower.displayDevice.timeToEmpty)
            property bool showTimeLeft: false
            onShowTimeLeftChanged: {
                text = showTimeLeft ? batteryTimeTillEmpty : batteryText
            }
            onBatteryTimeTillEmptyChanged: {
                if(showTimeLeft){
                    text = batteryTimeTillEmpty
                }
            }
            onBatteryTextChanged: {
                if(!showTimeLeft){
                    text = batteryText
                }
            }
            text: showTimeLeft ? batteryTimeTillEmpty : batteryText
            anchors.verticalCenter: parent.verticalCenter
            color: parent.color;
            font {
                family: "JetBrainsMono Nerd Font Mono"
                pixelSize: 16
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    textItem.showTimeLeft = !textItem.showTimeLeft
                }
            }
        }
    }
}
