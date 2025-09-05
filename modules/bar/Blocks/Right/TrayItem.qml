pragma ComponentBehavior: Bound

import Quickshell.Services.SystemTray
import QtQuick
import Quickshell.Widgets
import Quickshell

Rectangle {
    id: root
    anchors {
        bottom: parent.bottom
        top: parent.top
    }
    width: 20
    color: "transparent"

    required property SystemTrayItem modelData
    MouseArea {

        acceptedButtons: Qt.LeftButton | Qt.RightButton
        implicitWidth: 20
        implicitHeight: 20
        anchors.verticalCenter: parent.verticalCenter

        onClicked: event => {
            if (event.button === Qt.LeftButton)
                root.modelData.activate();
            else
                root.modelData.secondaryActivate();
        }

        IconImage {
            id: icon
            anchors.fill: parent
            source: {
                let icon = root.modelData.icon;
                if (icon.includes("?path=")) {
                    const [name, path] = icon.split("?path=");
                    icon = `file://${path}/${name.slice(name.lastIndexOf("/") + 1)}`;
                }
                return icon;
            }

            // layer.enabled: Config.bar.tray.recolour
            colour: "#ff0000"
            required property color colour
            property color dominantColour

            asynchronous: true

            layer.enabled: true
            // layer.effect: Colouriser {
            //     sourceColor: root.dominantColour
            //     colorizationColor: root.colour
            // }

            // layer.onEnabledChanged: {
            //     if (layer.enabled && status === Image.Ready)
            //         CUtils.getDominantColour(this, c => dominantColour = c);
            // }

            // onStatusChanged: {
            //     if (layer.enabled && status === Image.Ready)
            //         CUtils.getDominantColour(this, c => dominantColour = c);
            // }
        }
    }
    QsMenuOpener {
        id: menuOpener
        menu: root.modelData.menu

        onMenuChanged: console.log(menuOpener.children.values)
    }

    FloatingWindow {

        Repeater {
            id: menuRepeater
            model: menuOpener.children.values
            Text {
                required property QsMenuEntry modelData
                text: modelData.text
            }
        }
    }
}
