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

    Component.onCompleted:
    {
        for (let i = 0; i < CollectionBroker.count(); i++)
        {
            musicListTabBar.addMusicList(CollectionBroker.findCollection(i).name)
        }

        musicListTabBar.tabSelected.connect(function(name) {
            musicListMenu.menuName = name
            let collection = CollectionBroker.findCollection(musicListTabBar.currentIndex)
            musicListMenu.clear()
            for (let i = 0; i < collection.count(); i++)
            {
                musicListMenu.addSong(collection.getSong(i))
            }
            musicListMenu.setEditable(musicListTabBar.currentIndex > 1)
        })
    }

    Connections {
        target: musicListMenu
        function onRenameRequested(newName) {
            musicListTabBar.setTabName(musicListTabBar.currentIndex, newName)
            musicListMenu.menuName = newName
        }
    }
}
