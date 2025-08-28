//@ pragma UseQApplication

import QtQuick
import Quickshell
import "./modules/"

ShellRoot {
    id: root

    Loader {
        active: true
        sourceComponent: Root {}
    }
}
