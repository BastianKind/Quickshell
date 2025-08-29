import QtQuick
import Quickshell.Services.SystemTray

Repeater {
    id: items

    model: SystemTray.items

    TrayItem {}
}
