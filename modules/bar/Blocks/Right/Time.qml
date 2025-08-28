import QtQuick

Text {
    id: timeDisplay

    property string currentTime: ""
    property string currentDate: ""
    property bool showDate: false
    text: showDate ? currentDate : currentTime

    color: "#ffffff"
    font.pixelSize: 16
    font.family: "JetBrainsMono"

    anchors.verticalCenter: parent.verticalCenter

    MouseArea {
        anchors.fill: parent
        onClicked: timeDisplay.showDate = !timeDisplay.showDate
        cursorShape: Qt.PointingHandCursor
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            var now = new Date()
            timeDisplay.currentTime = Qt.formatTime(now, "hh:mm:ss")
            timeDisplay.currentDate = Qt.formatDateTime(now, "hh:mm:ss | dddd, dd. MMMM yyyy")    
        }
    }

    Component.onCompleted: {
        var now = new Date()
        currentTime = Qt.formatTime(now, "hh:mm:ss")
        currentDate = Qt.formatDateTime(now, "hh:mm:ss | dddd dd, MMMM. yyyy")    
    }
}
