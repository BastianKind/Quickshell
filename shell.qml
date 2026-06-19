//@ pragma UseQApplication

import QtQuick
import Quickshell
import "./modules/"
import qs.modules.lockscreen

ShellRoot {
    id: root

    Loader {
        active: true
        sourceComponent: Root {}
    }
    LockScreen {
        id: lockScreen
    }
}
