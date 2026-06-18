import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import OurMusic

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
    MusicListMenu
    {
        id: musicListMenu
        anchors.left: musicListTabBar.right
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: playerController.top
    }
    Song
    {
        id:song
    }

    Component.onCompleted:
    {
        musicListTabBar.addMusicList("233")
        musicListTabBar.addMusicList("2333")
        musicListTabBar.addMusicList("23333")

        musicListMenu.addSong(song)
    }

    Connections {
        target: musicListMenu
        function onRenameRequested(newName) {
            // 1. 更新标签页按钮文字（第一个标签）
            musicListTabBar.setTabName(0, newName)
            // 2. 更新当前菜单标题（因为 menuName 是属性绑定，需要手动修改）
            musicListMenu.menuName = newName
        }
    }
}
