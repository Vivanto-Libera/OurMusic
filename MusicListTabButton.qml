import QtQuick
import QtQuick.Controls

TabButton {
    // 美化背景
    background: Rectangle {
        color: parent.checked ? "#e84c3d" : (parent.hovered ? "#f0f0f0" : "white")
        radius: 6
    }
    // 美化文字
    contentItem: Text {
        text: parent.text
        color: parent.checked ? "white" : "black"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 14
    }
}