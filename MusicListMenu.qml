import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "utiles.js" as Utiles
import OurMusic

Item {
    id: root

    property string menuName: "Name"
    property ListModel songModel: ListModel{}
    property bool editable: true
    property int currentCollectionIndex: 0
    property string pendingSongUrl: ""

    signal deletePlaylist()
    signal addSongRequested()
    signal renameRequested(string name)
    signal addSongToPlaylistRequested(string songName, string url)
    signal playSongRequested(string url, string songName)
    signal deleteRequested(string url)


    Text {
        id: name
        text: menuName
        anchors.top: parent.top
        font.pixelSize: 24
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Button {
        id: edit
        width: name.height
        height: name.height
        anchors.verticalCenter: name.verticalCenter
        anchors.left: name.right
        anchors.leftMargin: 10
        background: Rectangle {
            color: "transparent"
        }
        icon.source: "qrc:/icons/edit.svg"
        visible: root.editable
        onClicked: {
            nameInput.text = root.menuName
            renameDialog.open()
        }
        ToolTip{
            visible: edit.hovered
            text: "重命名歌单"
            delay: 500
        }
    }

    Button {
        id: deleteBtn
        width: name.height
        height: name.height
        anchors.verticalCenter: name.verticalCenter
        anchors.left: edit.right
        anchors.leftMargin: 6
        background: Rectangle {
            color: "transparent"
        }
        icon.source: "qrc:/icons/delete.svg"
        display: icon.source ? AbstractButton.IconOnly : AbstractButton.TextOnly
        visible: root.editable
        onClicked: root.deletePlaylist()
        ToolTip{
            visible: deleteBtn.hovered
            text: "删除歌单"
            delay: 500
        }
    }

    Button {
        id: addBtn
        width: name.height
        height: name.height
        anchors.verticalCenter: name.verticalCenter
        anchors.left: deleteBtn.right
        anchors.leftMargin: 6
        background: Rectangle {
            color: "transparent"
        }
        icon.source: "qrc:/icons/add.svg"
        display: icon.source ? AbstractButton.IconOnly : AbstractButton.TextOnly
        visible: root.editable
        onClicked: {
            let allSongs = SongBroker.singleton().getAllSongs()
            songSelectionModel.clear()
            
            let existingUrls = []
            for (let j = 0; j < root.songModel.count; j++) {
                existingUrls.push(root.songModel.get(j).url)
            }
            
            for (let i = 0; i < allSongs.length; i++) {
                let song = allSongs[i]
                if (existingUrls.indexOf(song.url) === -1) {
                    songSelectionModel.append({
                        "name": song.name,
                        "url": song.url,
                        "selected": false
                    })
                }
            }
            addSongDialog.open()
        }
        ToolTip{
            visible: addBtn.hovered
            text: "添加歌曲"
            delay: 500
        }
    }

    Column {
        id: column
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: name.bottom
        anchors.bottom: parent.bottom
        Repeater {
            model: root.songModel
            SongItem
            {
                songName: model.name
                album: model.album
                singer: model.singer
                duration: model.duration
                isLiked: model.isLiked
                url: model.url
                width: root.width - 16

                onPlayClicked: {
                    root.playSongRequested(model.url, model.name)
                }

                onAddToPlaylistClicked: {
                    root.addSongToPlaylistRequested(model.name, model.url)
                }

                onCollected: {
                    root.openCollectionSelector(url)
                }
                onDeleteClicked: {
                    root.deleteRequested(model.url)
                }
            }
        }
    }

    function addSong(song) {
        if (!song || !song.url || song.url === "") {
            console.warn("Invalid song or empty URL, skip adding.")
            return
        }
        songModel.append({
            "name": song.name,
            "album": song.album,
            "singer": song.singer,
            "duration": Utiles.trans(song.duration),
            "isLiked": song.liked,
            "url": song.url
        })
    }

    function clear()
    {
        songModel.clear()
    }

    function setEditable(editable) {
        if (typeof editable === "boolean") {
            root.editable = editable
            edit.visible = editable
            deleteBtn.visible = editable
            addBtn.visible = editable
        }
    }

    function openCollectionSelector(url) {
        pendingSongUrl = url
        collectionSelectorDialog.open()
    }

    ListModel {
        id: songSelectionModel
    }
    // 对话框：添加歌曲
    Dialog {
        id: addSongDialog
        title: "选择要添加的歌曲"
        modal: true
        width: 300
        height: 400
        anchors.centerIn: parent

        background: Rectangle {
            color: "white"
            radius: 10
            border.color: "#e0e0e0"
            border.width: 1
        }

        header: Rectangle {
            height: 40
            color: "#f5f5f5"
            radius: 10
            clip: true

            Text {
                text: "选择要添加的歌曲"
                font.pixelSize: 16
                font.bold: true
                color: "#333333"
                anchors.centerIn: parent
            }
        }

        contentItem: ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 12

            // 歌曲列表（有数据时显示）
            ListView {
                id: songListView
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                model: songSelectionModel
                visible: songSelectionModel.count > 0

                delegate: Rectangle {
                    width: ListView.view.width
                    height: 40
                    color: "transparent"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        spacing: 8

                        CheckBox {
                            id: checkBox
                            checked: model.selected
                            onCheckedChanged: {
                                model.selected = checked
                            }
                        }

                        Text {
                            text: model.name
                            font.pixelSize: 14
                            color: "#222222"
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }
                }
            }

            // 空状态提示（无数据时显示，居中）
            Text {
                text: "暂无歌曲可添加"
                color: "#999999"
                font.pixelSize: 14
                visible: songSelectionModel.count === 0
                Layout.fillWidth: true
                Layout.fillHeight: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            // 确认/取消按钮
            RowLayout {
                Layout.alignment: Qt.AlignRight
                spacing: 12

                Button {
                    text: "取消"
                    implicitWidth: 80
                    onClicked: addSongDialog.close()
                }
                Button {
                    text: "确认"
                    implicitWidth: 80
                    background: Rectangle {
                        color: "#e84c3d"
                        radius: 6
                    }
                    contentItem: Text {
                        text: "确认"
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 14
                    }
                    onClicked: {
                        let selectedUrls = []
                        for (let i = 0; i < songSelectionModel.count; i++) {
                            let item = songSelectionModel.get(i)
                            if (item.selected) {
                                selectedUrls.push(item.url)
                            }
                        }
                        let collection = CollectionBroker.singleton().findCollection(root.currentCollectionIndex)
                        let songBroker = SongBroker.singleton()
                        for (let j = 0; j < selectedUrls.length; j++) {
                            let url = selectedUrls[j]
                            collection.addSong(url)
                            let song = songBroker.findSongByUrl(url)
                            if (song) {
                                root.addSong(song)
                            }
                        }
                        addSongDialog.close()
                    }
                }
            }
        }
    }
    // 对话框：重命名歌单
    Dialog {
        id: renameDialog
        title: ""
        modal: true
        width: 180
        height: 150
        standardButtons: Dialog.Ok | Dialog.Cancel
        anchors.centerIn: parent
        header: Rectangle {
                height: 20
                color: "lightgrey"
                radius: 12
                clip: true

                Text {
                    text: "重命名歌单"
                    font.pixelSize: 15
                    color: "#333333"
                    anchors.centerIn: parent
                }
        }
        background: Rectangle {
            color: "white"
            radius: 10
            border.color: "white"
            border.width: 1
        }
        contentItem:
            ColumnLayout {
                spacing: 10
                anchors.fill: parent
                anchors.margins: 16

                TextField {
                    id: nameInput
                    Layout.fillWidth: true
                    text: root.menuName
                    placeholderText: "请输入新名称"
                    focus: true
                    selectByMouse: true
                    background: Rectangle {
                                    color: "#f5f5f5"
                                    radius: 6
                                    border.color: "#d0d0d0"
                                    border.width: 1
                    }
                    onAccepted: renameDialog.accept()
                }
            }

            onAccepted: {
                let newName = nameInput.text.trim()
                if (newName !== "" && newName !== root.menuName) {
                    root.renameRequested(newName)
                }
            }
    }
    // 对话框：选择歌单
    Dialog {
        id: collectionSelectorDialog
        title: "选择要加入的歌单"
        modal: true
        width: 300
        height: 400
        anchors.centerIn: parent

        background: Rectangle {
            color: "white"
            radius: 10
            border.color: "#e0e0e0"
            border.width: 1
        }

        header: Rectangle {
            height: 40
            color: "#f5f5f5"
            radius: 10
            clip: true
            Text {
                text: "选择要加入的歌单"
                font.pixelSize: 16
                font.bold: true
                color: "#333333"
                anchors.centerIn: parent
            }
        }

        contentItem: Item {
            anchors.fill: parent

            ListView {
                id: collectionListView
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                    top: parent.top
                    topMargin: collectionSelectorDialog.header.height
                }
                clip: true
                model: ListModel { id: collectionListModel }

                delegate: Rectangle {
                    width: parent.width
                    height: 40
                    color: mouseArea.containsMouse ? "#f0f0f0" : "white"

                    Text {
                        text: model.name
                        anchors.centerIn: parent
                        font.pixelSize: 16
                        color: "#222222"
                    }
                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            if (model.index >= 0 && root.pendingSongUrl !== "") {
                                let target = CollectionBroker.singleton().findCollection(model.index)
                                if (target) {
                                    target.addSong(root.pendingSongUrl)
                                    // 如果当前显示的歌单就是目标，刷新 UI
                                    if (model.index === root.currentCollectionIndex) {
                                        let song = SongBroker.singleton().findSongByUrl(root.pendingSongUrl)
                                        if (song) {
                                            root.addSong(song)
                                        }
                                    }
                                }
                            }
                            collectionSelectorDialog.close()
                        }
                    }
                }

                // 空状态提示
                Text {
                    anchors.centerIn: parent
                    text: "暂无自定义歌单\n请先创建歌单"
                    color: "#999999"
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    visible: collectionListModel.count === 0
                }
            }
        }

        onOpened: {
            collectionListModel.clear()
            var count = CollectionBroker.singleton().count()
            for (var i = 2; i < count; i++) {
                var coll = CollectionBroker.singleton().findCollection(i)
                collectionListModel.append({"name": coll.name, "index": i})
            }
        }

        Connections {
                target: musicListMenu
                function onDeletePlaylist() {
                    let broker = CollectionBroker.singleton()
                    let index = musicListTabBar.currentIndex
                    if (index > 1) {
                        broker.deleteCollection(index)
                        musicListTabBar.tabModel.remove(index)
                        musicListTabBar.setCurrentIndex(0)
                        musicListTabBar.tabSelected()
                    } else {
                        console.warn("不能删除内置歌单")
                    }
                }
            }

            onClosed: function()
            {
                CollectionBroker.singleton().save()
                SongBroker.singleton().save()
            }
      }
}