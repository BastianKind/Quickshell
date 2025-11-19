pragma Singleton
import Quickshell

Singleton {
    PersistentProperties{
        id: properties
        reloadableId: "PowerMenuHandler"
        property bool powerMenu: false
        property string screenName: ""
    }

    property alias powerMenu: properties.powerMenu
    property alias screenName: properties.screenName
    function togglePowerMenu(originScreenName, originPowerMenu) {
        if (originPowerMenu) {
            // Opening menu - set screen name first, then enable
            properties.screenName = originScreenName
            properties.powerMenu = true
        } else {
            // Closing menu - just disable, keep screen name
            properties.powerMenu = false
        }
    }
}