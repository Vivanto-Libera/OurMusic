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
        icon.source: "qrc:/icons/edit.svg"
        visible: root.editable
        onClicked: {
            nameInput.text = root.menuName
            renameDialog.open()
        }
    }

    Button {
        id: deleteBtn
        width: name.height
        height: name.height
        anchors.verticalCenter: name.verticalCenter
        anchors.left: edit.right
        anchors.leftMargin: 6
        icon.source: "qrc:/icons/delete.svg"
        display: icon.source ? AbstractButton.IconOnly : AbstractButton.TextOnly
        visible: root.editable
        onClicked: root.deletePlaylist()
    }

    Button {
        id: addBtn
        width: name.height
        height: name.height
        anchors.verticalCenter: name.verticalCenter
        anchors.left: deleteBtn.right
        anchors.leftMargin: 6
        icon.source: "qrc:/icons/add.svg"
        display: icon.source ? AbstractButton.IconOnly : AbstractButton.TextOnly
        visible: root.editable
        onClicked: root.addSongRequested()
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
                width: root.width - 16
            }
        }
    }

    function addSong(song)
    {
        songModel.append({"name": song.name, "album": song.album, "singer": song.singer, "duration": Utiles.trans(song.duration), "isLiked": song.isLiked, "url": song.url})
    }

    function setEditable(editable) {
        if (typeof editable === "boolean") {
            root.editable = editable
            edit.visible = editable
            deleteBtn.visible = editable
            addBtn.visible = editable
        }
    }

    signal deletePlaylist()
    signal addSongRequested()
    signal renameRequested(string name)

    Dialog {
        id: renameDialog
        title: "重命名歌单"
        modal: true
        standardButtons: Dialog.Ok | Dialog.Cancel

        ColumnLayout {
            spacing: 10
            anchors.fill: parent

            TextField {
                id: nameInput
                Layout.fillWidth: true
                placeholderText: "请输入新名称"
                focus: true
                selectByMouse: true
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
