pragma ComponentBehavior: Bound

import Quickshell.Services.SystemTray
import QtQuick
import Quickshell.Widgets
import Quickshell

MouseArea {
    id: root

    required property SystemTrayItem modelData
    required property var rootWindow

    implicitWidth: height

    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

    anchors {
        top: parent.top
        bottom: parent.bottom
    }
    cursorShape: Qt.PointingHandCursor

    onClicked: event => {
        const menu = modelData;
        if (event.button === Qt.LeftButton && !menu.onlyMenu)
            modelData.activate();
        else if (event.button === Qt.MiddleButton)
            modelData.secondaryActivate();
        else {
            if (menu.hasMenu) {
                var pos = root.mapToGlobal(Qt.point(event.x, event.y));
                menu.display(rootWindow, pos.x + (event.x * 2), 0);
            }
        }
    }

    IconImage {
        id: icon
        implicitWidth: 20
        implicitHeight: 20
        anchors.verticalCenter: parent.verticalCenter
        source: {
            let icon = root.modelData.icon;
            if (icon.includes("?path=")) {
                const [name, path] = icon.split("?path=");
                icon = `file://${path}/${name.slice(name.lastIndexOf("/") + 1)}`;
            }
            return icon;
        }
        colour: "#ff0000"
        required property color colour
        property color dominantColour
        asynchronous: true
        layer.enabled: true

        Rectangle {
            anchors.fill: parent
            color: icon.dominantColour
            opacity: 0
        }
    }
}
