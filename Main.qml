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
        id: playerController
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }

    MusicListTabBar {
        id: musicListTabBar
        y: 320
        width: 160
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: playerController.top
    }
}
