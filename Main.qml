import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import OurMusic

Window {
    id: window
    width: 1080
    height: 640
    visible: true
    title: qsTr("OurMusic")
    color: "#f5f5f5"

    Rectangle {
        id: titleBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: musicListMenu.left
        height: 60
        color: "#ffffff"
        z: 1  // 在顶层
        Row {
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            spacing: 12
            // Logo 图标
            Image {
                id: logoImage
                width: 36
                height: 36
                source: "qrc:/icons/logo.svg"
                fillMode: Image.PreserveAspectFit
            }
            // OurMusic 文本
            Text {
                text: "OurMusic"
                font.pixelSize: 18
                font.bold: true
                color: "#e84c3d"
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    PlayerControllerItem {
        id: playerController
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }

    MusicListTabBar {
        id: musicListTabBar
        width: 160
        anchors.left: parent.left
        anchors.top: titleBar.bottom
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

        musicListMenu.menuName = musicListTabBar.tabModel.get(0).text
        musicListMenu.addSong(song)

        musicListTabBar.tabSelected.connect(function(name) {
            musicListMenu.menuName = name

        })
    }

    Connections {
        target: musicListMenu
        function onRenameRequested(newName) {
            // 1. 更新标签页按钮文字（第一个标签）
            musicListTabBar.setTabName(musicListTabBar.currentIndex, newName)
            // 2. 更新当前菜单标题
            musicListMenu.menuName = newName
        }
    }

    Connections{
        target: musicListMenu
        function onAddSongToPlaylistRequested(songName){
            playerController.addToPlaylist(songName)
            console.log("已添加至播放列表", songName)
        }
    }
}
