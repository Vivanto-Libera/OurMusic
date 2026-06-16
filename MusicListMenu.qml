import QtQuick
import QtQuick.Controls

Item {
    id: root
    property ListModel songModel: ListModel{}
    Text {
        id: name
        text: qsTr("Name")
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
                songName: model.text
                width: root.width - 16
            }
        }
    }
    function addSong(name)
    {
        songModel.append({"text": name})
    }

}
