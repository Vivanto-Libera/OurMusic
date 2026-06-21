import QtQuick
import QtQuick.Controls
import "transSecondsToTimeString.js" as trans

Item {
    id: root
    property string menuName: "Name"
    property ListModel songModel: ListModel{}
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
        songModel.append({"name": song.name, "album": song.album, "singer": song.singer, "duration": trans.trans(song.duration), "isLiked": song.isLiked})
    }

}
