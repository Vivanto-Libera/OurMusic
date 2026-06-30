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
        z: 1
        Row {
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            spacing: 12
            Image {
                id: logoImage
                width: 36
                height: 36
                source: "qrc:/icons/logo.svg"
                fillMode: Image.PreserveAspectFit
            }
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

    MusicListMenu {
        id: musicListMenu
        anchors.left: musicListTabBar.right
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: playerController.top
    }

    function refreshCurrentCollection() {
        var broker = CollectionBroker.singleton()
        var collection = broker.findCollection(musicListTabBar.currentIndex)
        if (!collection) return

        musicListMenu.menuName = collection.name
        musicListMenu.clear()

        if (musicListTabBar.currentIndex === 1) {
            broker.reloadLikedMusic()
        } else if (musicListTabBar.currentIndex === 0) {
            broker.reloadAllMusic()
        }

        for (var j = 0; j < collection.count(); j++) {
            var songUrl = collection.getSong(j)
            var song = SongBroker.singleton().findSongByUrl(songUrl)
            if (song) {
                musicListMenu.addSong(song)
            }
        }

        musicListMenu.setEditable(musicListTabBar.currentIndex > 1)
        musicListMenu.currentCollectionIndex = musicListTabBar.currentIndex
    }

    Component.onCompleted: {
        var broker = CollectionBroker.singleton()
        for (var i = 0; i < broker.count(); i++) {
            var collection = broker.findCollection(i)
            if (collection) {
                musicListTabBar.addMusicList(collection.name)
            }
        }

        musicListTabBar.tabSelected.connect(function() {
            refreshCurrentCollection()
        })

        musicListTabBar.setCurrentIndex(0)
        musicListTabBar.tabSelected()

        musicListTabBar.songAdded.connect(function(filePath) {
            SongBroker.singleton().addSong(filePath)
            SongBroker.singleton().save()
        })

        playerController.likeToggled.connect(function(url, liked) {
            refreshCurrentCollection()
        })
    }

    Connections {
        target: musicListMenu
        function onRenameRequested(newName) {
            musicListTabBar.setTabName(musicListTabBar.currentIndex, newName)
            musicListMenu.menuName = newName
            CollectionBroker.singleton().findCollection(musicListTabBar.currentIndex).name = newName
        }
    }

    Connections {
        target: musicListMenu
        function onAddSongToPlaylistRequested(songName, url) {
            playerController.addToPlaylist(songName, url)
        }
    }

    Connections {
        target: musicListMenu
        function onPlaySongRequested(url, songName) {
            let collection = CollectionBroker.singleton().findCollection(musicListTabBar.currentIndex)
            let songs = []
            for (let i = 0; i < collection.count(); i++) {
                let songUrl = collection.getSong(i)
                let song = SongBroker.singleton().findSongByUrl(songUrl)
                if (song) {
                    songs.push({"name": song.name, "url": song.url})
                }
            }
            playerController.setPlaylist(songs)
            let index = songs.findIndex(function(s) { return s.url === url })
            playerController.playAtIndex(index)
        }
    }

    Connections {
        target: playerController
        function onCollectRequested(url) {
            musicListMenu.openCollectionSelector(url)
        }
    }

    onClosing: function() {
        CollectionBroker.singleton().save()
        SongBroker.singleton().save()
    }
}