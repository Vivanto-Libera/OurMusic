import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    width: 600
    height: 80
    property string songName: "歌曲名称"
    property string duration: "00:00"
    property bool isLiked: false
    property bool isFavorited: false

    Rectangle{
        anchors.bottom: parent.bottom
        width: parent.width
        height: 10
        color: "red"
    }

    Row{
        anchors.centerIn: parent
        spacing: 10

        Button{
            id: play
            width: 60
            height: 30
            font.pixelSize: 20
            icon.source: "icons/play.svg"
            font.weight: Font.Medium
        }

        Text{
            width: 120
            text: "歌曲名称"
            font.pixelSize: 20
            font.weight: Font.DemiBold
        }

       Button{
           width: 60
           height: 30
           font.pixelSize: 20
           icon.source: "icons/like_empty.svg"
        }

        Button{
            width: 60
            height: 30
            font.pixelSize: 20
            icon.source: "icons/collection.svg"
        }

        Button{
            width: 60
            height: 30
            text: "删除"
            font.pixelSize: 20
        }

        Text{
            width: 60
            height: 30
            text: "00:00"
            font.pixelSize: 20
        }
    }
}
