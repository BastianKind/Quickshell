import QtQuick

Item {
    id: root

    property alias text: textItem.text
    property alias horizontalAlignment: textItem.horizontalAlignment
    property alias pixelSize: textItem.font.pixelSize
    property alias fontFamily: textItem.font.family

    property var backgroundSource
    property Item wallpaper

    implicitWidth: textItem.implicitWidth
    implicitHeight: textItem.implicitHeight

    width: implicitWidth
    height: implicitHeight

    Text {
        id: textItem

        visible: false

        color: "white"
        font.bold: true
    }

    ShaderEffectSource {
        id: textMaskElement

        sourceItem: textItem
        hideSource: true
        live: true
    }

    ShaderEffect {
        anchors.fill: parent

        property var background: root.backgroundSource
        property var textMask: textMaskElement

        property point itemPos: Qt.point(root.x, root.y)
        property size itemSize: Qt.size(root.width, root.height)

        property real bgWidth: root.wallpaper.width
        property real bgHeight: root.wallpaper.height

        vertexShader: "invert.vert.qsb"
        fragmentShader: "invert.frag.qsb"
    }
}
