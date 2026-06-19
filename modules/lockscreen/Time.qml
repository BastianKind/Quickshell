import QtQuick

InvertedText {
    id: timeDisplay

    property string currentTime: ""
    property string currentDate: ""
    property bool showDate: false
    text: currentDate
    horizontalAlignment: Text.AlignHCenter

    pixelSize: 96
    fontFamily: "JetBrainsMono Nerd Font Mono"

    function setTime() {
        var now = new Date();
        timeDisplay.currentTime = Qt.formatTime(now, "hh:mm:ss\n");
        timeDisplay.currentDate = Qt.formatDateTime(now, "hh:mm:ss\ndd. MMMM yyyy");
    }

    MouseArea {
        anchors.fill: parent
        onClicked: timeDisplay.showDate = !timeDisplay.showDate
        cursorShape: Qt.PointingHandCursor
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: timeDisplay.setTime()
    }

    Component.onCompleted: setTime()
}
