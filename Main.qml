import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: window
    width: 1080
    height: 640
    visible: true
    title: qsTr("音乐播放器")
    color: "#f5f5f5"
    PlayerControllerItem {
        id: playerControllerItem
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }
}
