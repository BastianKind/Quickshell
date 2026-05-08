import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtCore

PanelWindow {
    id: root
    property var modelData
    screen: modelData

    property bool useCustomWallpaper: true

    property string wallpaperName: "default.gif"
    readonly property url defaultPath: Qt.resolvedUrl("../../wallpapers/" + wallpaperName)
    readonly property string homeDir: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]

    property string customWallpaperPath: ""

    readonly property url activePath: customWallpaperPath !== ""
        ? Qt.url(customWallpaperPath)
        : defaultPath

    readonly property bool isGif: activePath.toString().endsWith(".gif")

    anchors { top: true; bottom: true; left: true; right: true }
    WlrLayershell.layer: WlrLayer.Background
    exclusionMode: ExclusionMode.Ignore
    color: "black"

    IpcHandler {
        target: "wallpaper"

        function expandPath(path: string): string {
            if (path.startsWith("~/")) {
                return root.homeDir + "/" + path.slice(2)  // fixed: add file://
            } else if (path.startsWith("/")) {
                return "file://" + path
            } else {
                return path
            }
        }

        function set(path: string): void {
            const expanded = expandPath(path)
            if (expanded.startsWith("file://")) {
                root.customWallpaperPath = expanded
            } else {
                root.customWallpaperPath = root.defaultPath.toString()
                    .replace(/[^/]*$/, expanded)
            }
        }

        function reset(): void {
            root.customWallpaperPath = ""
        }

        function get(): string {
            return root.activePath.toString()
        }

        function toggleQSWallpaper(): void {
            root.useCustomWallpaper = !root.useCustomWallpaper
        }
    }

    Item {
        anchors.fill: parent
        visible: root.useCustomWallpaper

        Image {
            anchors.fill: parent
            source: root.isGif ? "" : root.activePath
            fillMode: Image.PreserveAspectCrop
            visible: !root.isGif
            cache: false
        }

        AnimatedImage {
            anchors.fill: parent
            source: root.isGif ? root.activePath : ""
            fillMode: AnimatedImage.PreserveAspectCrop
            visible: root.isGif
            playing: root.isGif
            cache: false
        }
    }
}