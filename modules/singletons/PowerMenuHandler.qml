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
            properties.screenName = originScreenName
            properties.powerMenu = true
        } else {
            properties.powerMenu = false
        }
    }
}