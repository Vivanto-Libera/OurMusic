import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import OurMusic

ApplicationWindow {
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
        let broker = CollectionBroker.singleton()
        let collection = broker.findCollection(musicListTabBar.currentIndex)
        if (!collection) return

        musicListMenu.menuName = collection.name
        musicListMenu.clear()

        if (musicListTabBar.currentIndex === 1) {
            broker.reloadLikedMusic()
        } else if (musicListTabBar.currentIndex === 0) {
            broker.reloadAllMusic()
        }

        for (let j = 0; j < collection.count(); j++) {
            let songUrl = collection.getSong(j)
            let song = SongBroker.singleton().findSongByUrl(songUrl)
            if (song) {
                musicListMenu.addSong(song)
            }
        }

        musicListMenu.setEditable(musicListTabBar.currentIndex > 1)
        musicListMenu.currentCollectionIndex = musicListTabBar.currentIndex
    }

    function handleDeleteSong(url) {
        let broker = CollectionBroker.singleton()
        let currentIndex = musicListTabBar.currentIndex
        let currentCollection = null

        if (currentIndex === 0) {
            // 全部音乐：彻底删除
            let allSongs = SongBroker.singleton().getAllSongs()
            let found = false
            for (let i = 0; i < allSongs.length; i++) {
                if (allSongs[i].url === url) {
                    found = true
                    break
                }
            }
            if (!found) return

            // 从所有歌单中移除
            for (let idx = 0; idx < broker.count(); idx++) {
                let coll = broker.findCollection(idx)
                if (coll) {
                    coll.removeSongByUrl(url)
                }
            }
            SongBroker.singleton().removeSong(url)

            if (playerController.currentSongUrl === url) {
                playerController.stopMusic()
                playerController.currentSongUrl = ""
            }

            refreshCurrentCollection()
        } else if (currentIndex === 1) {
            // 我喜欢的音乐：取消喜欢
            let song = SongBroker.singleton().findSongByUrl(url)
            if (song) {
                song.setLiked(false)
            }
            currentCollection = broker.findCollection(currentIndex)
            if (currentCollection) {
                currentCollection.removeSongByUrl(url)
            }
            if (playerController.currentSongUrl === url) {
                playerController.updateLikeStatus()
            }
            refreshCurrentCollection()
        } else {
            // 自定义歌单：只从当前歌单移除
            currentCollection = broker.findCollection(currentIndex)
            if (currentCollection) {
                currentCollection.removeSongByUrl(url)
                refreshCurrentCollection()
            }
        }
    }

    Component.onCompleted: {
        let broker = CollectionBroker.singleton()
        for (let i = 0; i < broker.count(); i++) {
            let collection = broker.findCollection(i)
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
        })

        playerController.likeToggled.connect(function(url, liked) {
            if (musicListTabBar.currentIndex === 1) {
                refreshCurrentCollection()
            }
        })

        musicListMenu.deleteRequested.connect(function(url) {
            handleDeleteSong(url)
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
