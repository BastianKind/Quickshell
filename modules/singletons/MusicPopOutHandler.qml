pragma Singleton
import Quickshell

Singleton {
    PersistentProperties{
        id: properties
        reloadableId: "MusicPopOutHandler"
        property bool showMusicPopOut: false
        property string screenName: ""
    }

    property alias showMusicPopOut: properties.showMusicPopOut
    property alias screenName: properties.screenName
    function toggleMusicPopOut(originScreenName, originShowMusicPopOut) {
        if(originShowMusicPopOut) {
            properties.screenName = originScreenName
            properties.showMusicPopOut = true
        }
        else {
            properties.showMusicPopOut = originShowMusicPopOut;
        }
    }
}