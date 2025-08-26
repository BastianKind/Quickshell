import QtQuick

Text {
    id: timeDisplay

    property string currentTime: ""
    text: currentTime

    color: "#ffffff"
    font.pixelSize: 14
    font.family: "Inter, sans-serif"

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            var now = new Date()
            timeDisplay.currentTime = Qt.formatTime(now, "hh:mm:ss") + " | " + Qt.formatDate(now, "yyyy.MM.dd")
        }
    }

    Component.onCompleted: {
        var now = new Date()
        currentTime = Qt.formatTime(now, "hh:mm:ss") + " | " + Qt.formatDate(now, "yyyy.MM.dd")
    }
}
