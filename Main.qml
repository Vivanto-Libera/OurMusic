import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
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

    Component.onCompleted:
    {
        for (let i = 0; i < CollectionBroker.count(); i++)
        {
            musicListTabBar.addMusicList(CollectionBroker.findCollection(i).name)
        }

        musicListTabBar.tabSelected.connect(function() {
            let collection = CollectionBroker.findCollection(musicListTabBar.currentIndex)
            musicListMenu.menuName = collection.name;
            musicListMenu.clear()
            for (let i = 0; i < collection.count(); i++)
            {
                musicListMenu.addSong(collection.getSong(i))
            }
            musicListMenu.setEditable(musicListTabBar.currentIndex > 1)
        })
        musicListTabBar.setCurrentIndex(0)
        musicListTabBar.tabSelected()
    }

    Connections {
        target: musicListMenu
        function onRenameRequested(newName) {
            musicListTabBar.setTabName(musicListTabBar.currentIndex, newName)
            musicListMenu.menuName = newName
            CollectionBroker.findCollection(musicListTabBar.currentIndex).name = newName
        }
    }

    Connections{
        target: musicListMenu
        function onAddSongToPlaylistRequested(songName){
            playerController.addToPlaylist(songName)
        }
    }

    onClosing: function()
    {
        CollectionBroker.save()
        SongBroker.save()
    }
}
