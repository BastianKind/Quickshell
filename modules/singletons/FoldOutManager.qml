pragma Singleton
import Quickshell
import QtQml

Singleton {
    id: root
    
    signal foldoutChanged(string foldoutId)
    
    PersistentProperties {
        id: properties
        reloadableId: "FoldOutManager"
        property string foldoutsData: "{}"
    }
    
    property var foldouts: ({})
    
    property int changeCounter: 0
    
    Component.onCompleted: {
        try {
            foldouts = JSON.parse(properties.foldoutsData)
        } catch(e) {
            foldouts = {}
        }
    }
    
    function saveFoldouts() {
        properties.foldoutsData = JSON.stringify(foldouts)
    }
    
    function registerFoldout(foldoutId) {
        if (!foldouts[foldoutId]) {
            foldouts[foldoutId] = {
                open: false,
                screenName: ""
            }
            foldouts = foldouts
            changeCounter++
            saveFoldouts()
            foldoutChanged(foldoutId)
        }
    }
    
    function toggle(foldoutId, screenName, shouldOpen) {
        if (!foldouts[foldoutId]) {
            registerFoldout(foldoutId)
        }
        
        if (shouldOpen) {
            foldouts[foldoutId].open = true
            foldouts[foldoutId].screenName = screenName
        } else {
            foldouts[foldoutId].open = false
        }
        
        foldouts = foldouts
        changeCounter++  // Force binding update
        saveFoldouts()
        foldoutChanged(foldoutId)
    }
    
    function isOpen(foldoutId) {
        changeCounter  // Force dependency
        return foldouts[foldoutId]?.open ?? false
    }
    
    function getScreenName(foldoutId) {
        changeCounter  // Force dependency
        return foldouts[foldoutId]?.screenName ?? ""
    }
    
    function closeAll() {
        for (let id in foldouts) {
            foldouts[id].open = false
        }
        foldouts = foldouts
        changeCounter++
        saveFoldouts()
    }
    
    function isAnyOpenOnScreen(screenName) {
        changeCounter  // Force dependency
        for (let id in foldouts) {
            if (foldouts[id].open && foldouts[id].screenName === screenName) {
                return true
            }
        }
        return false
    }
}