import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import "utiles.js" as Utiles
import OurMusic

Rectangle {
    id: root
    width: 500
    height: 105
    color: "#ffffff"
    radius: 12
    border.color: "#dddddd"
    border.width: 1
    property alias durationText : duration.text
    property alias positionText : position.text

    property string currentSongName: PlayList.currentIndex >= 0 ? PlayList.getName(PlayList.currentIndex) : ""

    // MediaPlayer组件用于播放音乐
    MediaPlayer {
        id: mediaPlayer
        audioOutput: AudioOutput {
            volume: volumeSlider.value
        }
        autoPlay: false

        onDurationChanged: {
            durationText = Utiles.trans(mediaPlayer.duration)
        }

        onPositionChanged: {
            positionText = Utiles.trans(mediaPlayer.position)
            slider.value = mediaPlayer.duration > 0 ? mediaPlayer.position / mediaPlayer.duration : 0
        }

        onPlaybackStateChanged: {
            if (mediaPlayer.status === MediaPlayer.EndOfMedia) {
                nextMusic()
            }
        }
    }

    // 设置播放URL并播放（通过URL）
    function setUrl(url) {
        mediaPlayer.source = url
        mediaPlayer.play()
    }

    // 设置播放列表
    function setPlaylist(songs) {
        PlayList.clear()
        for (let i = 0; i < songs.length; i++) {
            PlayList.addSong(songs[i].name, songs[i].url)
        }
    }

    // 设置播放列表并从指定索引开始播放
    function playAtIndex(index) {
        if (index >= 0 && index < PlayList.count()) {
            PlayList.currentIndex = index
            let url = PlayList.getUrl(index)
            currentSongName = PlayList.getName(index)
            mediaPlayer.source = url
            mediaPlayer.play()
        }
    }

    // 播放当前歌曲
    function playMusic() {
        mediaPlayer.play()
    }

    // 暂停
    function pauseMusic() {
        mediaPlayer.pause()
    }

    // 停止
    function stopMusic() {
        mediaPlayer.stop()
    }

    // 上一曲
    function previousMusic() {
        let playlist = PlayList
        if (playlist.count() === 0) return
        
        let newIndex = playlist.previousIndex()
        if (newIndex >= 0) {
            playAtIndex(newIndex)
        }
    }

    // 下一曲
    function nextMusic() {
        let playlist = PlayList
        if (playlist.count() === 0) return
        
        let newIndex = playlist.nextIndex()
        if (newIndex >= 0) {
            playAtIndex(newIndex)
        }
    }

    // 添加歌曲到播放列表
    function addToPlaylist(songName, url) {
        PlayList.addSong(songName, url)
    }

    // 清空播放列表
    function clearPlaylist() {
        PlayList.clear()
    }

    // 删除播放列表中的歌曲
    function removeFromPlaylist(index) {
        PlayList.deleteSong(index)
    }

    // 获取当前播放列表索引
    function getCurrentIndex() {
        return PlayList.currentIndex
    }

    // 获取播放模式
    function getPlayMode() {
        return PlayList.playMode
    }

    // 设置播放模式
    function setPlayMode(mode) {
        PlayList.setPlayMode(mode)
    }

    // 左侧歌曲名称
    Text {
        id: name
        text: currentSongName
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: columnLayout.left
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 24
        font.bold: true
        color: "#222222"
        width: 120
        elide: Text.ElideRight
    }

    // 中间控制区域
    ColumnLayout {
        id: columnLayout
        anchors.centerIn: parent
        spacing: 8

        RowLayout {
            id: rowLayout0
            layoutDirection: Qt.LeftToRight
            spacing: 14

            Button {
                id: like
                icon.source: checked ? "qrc:/icons/like_red.svg" : "qrc:/icons/like_empty.svg"
                checkable: true
                icon.width: 26
                icon.height: 26
                flat: true
                implicitWidth: 42
                implicitHeight: 42
                ToolTip {
                    visible: like.hovered
                    text: "喜欢"
                    delay: 500
                }
            }

            Button {
                id: previous
                icon.source: "qrc:/icons/next.svg"
                flat: true
                icon.width: 28
                icon.height: 28
                implicitWidth: 46
                implicitHeight: 46
                onClicked: {
                    previousMusic()
                }
                ToolTip {
                    visible: previous.hovered
                    text: "上一曲"
                    delay: 500
                }
            }

            Button {
                id: play
                icon.source: mediaPlayer.playing ? "qrc:/icons/pause.svg" : "qrc:/icons/play.svg"
                icon.width: 32
                icon.height: 32
                background: Rectangle {
                    color: "#e84c3d"
                    radius: width / 2
                }
                implicitWidth: 54
                implicitHeight: 54
                onClicked: {
                    if (mediaPlayer.playing) {
                        mediaPlayer.pause()
                    } else {
                        mediaPlayer.play()
                    }
                }
                ToolTip {
                    visible: play.hovered
                    text: mediaPlayer.playing ? "暂停" : "播放"
                    delay: 500
                }
            }

            Button {
                id: next
                icon.source: "qrc:/icons/previous.svg"
                flat: true
                icon.width: 28
                icon.height: 28
                implicitWidth: 46
                implicitHeight: 46
                onClicked: {
                    nextMusic()
                }
                ToolTip {
                    visible: next.hovered
                    text: "下一曲"
                    delay: 500
                }
            }

            Button {
                id: loop_mode
                flat: true
                icon.width: 26
                icon.height: 26
                implicitWidth: 42
                implicitHeight: 42
                icon.source: {
                    switch(PlayList.playMode){
                        case 0: return "qrc:/icons/play_cycle.svg"
                        case 1: return "qrc:/icons/play_once.svg"
                        case 2: return "qrc:/icons/random.svg"
                    }
                }
                onClicked: {
                    let newMode = (PlayList.playMode + 1) % 3
                    PlayList.setPlayMode(newMode)
                    loop_mode.modeChanged(newMode)
                }
                signal modeChanged(int mode)

                ToolTip {
                    visible: loop_mode.hovered
                    text: {
                        switch(PlayList.playMode){
                        case 0: return "列表循环"
                        case 1: return "单曲循环"
                        case 2: return "随机循环"
                        default: return "列表循环"
                        }
                    }
                    delay: 500
                }
            }

            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }

        RowLayout {
            id: rowLayout1
            spacing: 10

            Text {
                id: position
                text: "00:00"
                font.pixelSize: 12
                color: "#888888"
            }

            Slider {
                id: slider
                width: 260
                value: 0
                snapMode: RangeSlider.NoSnap
                live: true
                Layout.preferredWidth: 260
                Layout.preferredHeight: 16
                onMoved: {
                    mediaPlayer.position = slider.value * mediaPlayer.duration
                }
                background: Rectangle {
                    implicitHeight: 4
                    radius: 2
                    color: "#e0e0e0"
                    Rectangle {
                        width: parent.width * (slider.position || 0)
                        height: parent.height
                        radius: 2
                        color: "#e84c3d"
                    }
                }
                handle: Rectangle {
                    id: handleRect
                    implicitWidth: 14
                    implicitHeight: 14
                    radius: 7
                    color: "white"
                    border.color: "#e84c3d"
                    border.width: 2
                    x: slider.leftPadding + (slider.availableWidth - width) * slider.visualPosition
                    y: (slider.availableHeight - height) / 2
                }
            }

            Text {
                id: duration
                text: "00:00"
                font.pixelSize: 12
                color: "#888888"
            }
        }
        Layout.fillWidth: false
    }

    // 右侧按钮组
    RowLayout {
        id: rowLayout
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 16
        spacing: 12

        Button {
            id: collect
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            icon.source: "qrc:/icons/collection.svg"
            flat: true
            icon.width: 24
            icon.height: 24
            implicitWidth: 40
            implicitHeight: 40
            ToolTip {
                visible: collect.hovered
                text: "收藏"
                delay: 500
            }
        }

        Button {
            id: volume
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            icon.source: volumeSlider.value === 0 ? "qrc:/icons/mute.svg" : "qrc:/icons/volume.svg"
            flat: true
            icon.width: 24
            icon.height: 24
            implicitWidth: 40
            implicitHeight: 40

            property real previousVolume: 0.5

            onClicked: volumePopup.open()

            onDoubleClicked: {
                if (volumeSlider.value > 0) {
                    previousVolume = volumeSlider.value
                    volumeSlider.value = 0
                } else {
                    volumeSlider.value = previousVolume > 0 ? previousVolume : 0.5
                }
            }

            Popup {
                id: volumePopup
                x: (volume.width - volumePopup.width) / 2
                y: -height - 10
                width: 70
                height: 190
                modal: false
                closePolicy: Popup.CloseOnPressOutside
                background: Rectangle {
                    color: "#ffffff"
                    radius: 8
                    border.color: "#dddddd"
                    border.width: 1
                }

                Column {
                    anchors.centerIn: parent
                    spacing: 6

                    Text {
                        id: volumeValueText
                        text: Math.round(volumeSlider.value * 100)
                        font.pixelSize: 14
                        font.bold: true
                        color: "#000000"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Slider {
                        id: volumeSlider
                        orientation: Qt.Vertical
                        from: 0
                        to: 1
                        value: 0.5
                        width: 20
                        height: 120
                        anchors.horizontalCenter: parent.horizontalCenter

                        background: Rectangle {
                            implicitWidth: 4
                            implicitHeight: 120
                            radius: 2
                            color: "red"
                            anchors.centerIn: parent

                            Rectangle {
                                height: parent.height * (1 - (volumeSlider.position || 0))
                                width: parent.width
                                radius: 2
                                color: "#e0e0e0"
                                anchors.top: parent.top
                            }
                        }

                        handle: Rectangle {
                            implicitWidth: 16
                            implicitHeight: 16
                            radius: 8
                            color: "white"
                            border.color: "red"
                            border.width: 2
                            x: (volumeSlider.availableWidth - width) / 2
                            y: volumeSlider.topPadding + (volumeSlider.availableHeight - height) * volumeSlider.visualPosition
                        }
                    }
                }
            }

            ToolTip {
                visible: volume.hovered
                text: "音量大小"
                delay: 500
            }
        }

        Button {
            id: music_menu
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            icon.source: "qrc:/icons/music_menu.svg"
            flat: true
            icon.width: 24
            icon.height: 24
            implicitWidth: 40
            implicitHeight: 40
            ToolTip {
                visible: music_menu.hovered
                text: "播放列表"
                delay: 500
            }
            onClicked: playlistDialog.open()
        }
    }

    // 播放列表对话框
    Dialog {
        id: playlistDialog
        title: ""
        modal: true
        z: 10
        x: parent.width - width - 10
        y: -height - 10
        width: 200
        height: 300

        header: Rectangle {
            height: 50
            color: "#f5f5f5"
            clip: true

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                Text {
                    id: playListText
                    text: "当前播放列表"
                    font.pixelSize: 15
                    font.bold: true
                    color: "#333333"
                    Layout.fillWidth: true
                }
            }
        }

        contentItem: ColumnLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: playListText.bottom
            anchors.margins: 8

            ListView {
                id: playlistListView
                Layout.fillWidth: true
                Layout.fillHeight: true

                model: ListModel {
                    id: playlistProxyModel
                }

                delegate: Rectangle {
                    width: playlistListView.width
                    height: 40
                    color: index === PlayList.currentIndex ? "#e84c3d" : (index % 2 === 0 ? "#f8f8f8" : "white")

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            playAtIndex(index)
                            playlistDialog.close()
                        }
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 4
                        spacing: 8

                        Image {
                            source: "qrc:/icons/play_black.svg"
                            width: 16
                            height: 16
                            visible: index === PlayList.currentIndex
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: model.songName
                            anchors.left: parent.left
                            anchors.leftMargin: index === PlayList.currentIndex ? 28 : 12
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 14
                            color: index === PlayList.currentIndex ? "white" : "#333333"
                        }

                        Button {
                            id: delBtn
                            anchors.right: parent.right
                            icon.source: "qrc:/icons/delete.svg"
                            background: Rectangle {
                                color: "transparent"
                            }
                            onClicked: {
                                PlayList.deleteSong(index)
                                updatePlaylistProxy()
                            }
                        }
                    }
                }
            }
        }

        onOpened: {
            updatePlaylistProxy()
        }
    }

    // 更新播放列表代理模型
    function updatePlaylistProxy() {
        playlistProxyModel.clear()
        let playlist = PlayList
        for (let i = 0; i < playlist.count(); i++) {
            playlistProxyModel.append({
                "songName": playlist.getName(i),
                "url": playlist.getUrl(i)
            })
        }
    }

    // 监听播放列表变化
    Connections {
        target: PlayList
        function onSongAdded() {
            updatePlaylistProxy()
        }
        function onSongRemoved() {
            updatePlaylistProxy()
        }
        function onListCleared() {
            updatePlaylistProxy()
        }
        function onCurrentIndexChanged() {
            currentSongName = PlayList.currentIndex >= 0 ? PlayList.getName(PlayList.currentIndex) : ""
        }
    }
}
