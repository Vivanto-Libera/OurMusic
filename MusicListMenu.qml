import QtQuick
import QtQuick.Controls
import "utiles.js" as Utiles
import OurMusic
import QtQuick.Layouts

Item {
    id: root

    property string menuName: "Name"
    property ListModel songModel: ListModel{}
    property bool editable: true

    signal deletePlaylist()
    signal addSongRequested()
    signal renameRequested(string name)
    signal addSongToPlaylistRequested(string songName)

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
        // 添加悬停文本提示
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
        // 添加悬停文本提示
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
        onClicked: root.addSongRequested()
        // 添加悬停文本提示
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

                onAddToPlaylistClicked: {
                    root.addSongToPlaylistRequested(model.name)
                }
            }
        }
    }

    function addSong(song)
    {
        songModel.append({"name": song.name, "album": song.album, "singer": song.singer, "duration": Utiles.trans(song.duration), "isLiked": song.liked, "url": song.url})
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

    Dialog {
        id: renameDialog
        title: ""
        modal: true
        width: 180
        height: 150
        standardButtons: Dialog.Ok | Dialog.Cancel
        anchors.centerIn: parent
        // 自定义标题栏
        header: Rectangle {
                height: 20
                color: "lightgrey"
                radius: 12
                // 只让顶部圆角生效
                clip: true

                Text {
                    text: "重命名歌单"
                    font.pixelSize: 15
                    color: "#333333"
                    anchors.centerIn: parent
                }
        }
        // 自定义背景
        background: Rectangle {
            color: "white"
            radius: 10
            border.color: "white"
            border.width: 1
        }
        // 输入区域
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
                    root.renameRequested(newName)   // 发送信号
                }
            }
    }
}
