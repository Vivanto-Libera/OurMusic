import QtQuick
import QtQuick.Controls
import OurMusic

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
        icon.source: "qrc:/icons/add-music.svg"
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
        let duratoinString
        let seconds
        let minutes
        minutes = parseInt(song.duration / 60)
        seconds = song.duration - minutes * 60
        let minStr = minutes.toString().padStart(2, "0")
        let secStr = seconds.toString().padStart(2, "0")
        duratoinString = minStr + ":" + secStr
        songModel.append({"name": song.name, "album": song.album, "singer": song.singer, "duration": duratoinString, "isLiked": song.isLiked})
    }

    function setEditable(editable) {
        if (typeof editable === "boolean") {
            root.editable = editable
        }
    }

    signal deletePlaylist()
    signal addSongRequested()
}
