import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    width: parent.width
    height: 72
    color: mouseArea.containsMouse ? "#f8fafc" : "white"

    property string songName: "歌曲名称"
    property string singer: "歌手"
    property string album: "专辑"
    property string duration: "03:30"
    property bool isLiked: false
    property bool isFavorited: false

    signal playClicked()
    signal editClicked()
    signal likeClicked(var liked)
    signal addToPlaylistClicked()
    signal favoriteClicked(var favorited)
    signal deleteClicked()

    // 分隔线
    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        color: "#edf2f7"
    }

    Row {
        anchors.fill: parent
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        spacing: 12

        // 播放按钮
        Button {
            id: playBtn
            width: 36
            height: 36
            anchors.verticalCenter: parent.verticalCenter
            icon.source: "qrc:/icons/play.svg"
            background: Rectangle {
                color: playBtn.pressed ? "#e2e8f0" : "#f1f5f9"
                radius: 18
            }
            onClicked: root.playClicked()
        }

        // 歌曲信息：歌名、歌手
        Column {
            width: 160
            spacing: 4
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: root.songName
                font.pixelSize: 16
                font.weight: Font.DemiBold
                color: "#0f172a"
                elide: Text.ElideRight
                width: parent.width
            }

            Text {
                text: root.singer
                font.pixelSize: 12
                color: "#64748b"
                elide: Text.ElideRight
                width: parent.width
            }
        }
        //专辑信息
        Text {
            text: root.album
            width: 120
            font.pixelSize: 13
            color: "#64748b"
            elide: Text.ElideRight
            anchors.verticalCenter: parent.verticalCenter
        }
        // 操作按钮组
        Row {
            spacing: 8
            anchors.verticalCenter: parent.verticalCenter

            Button {
                id: likeBtn
                width: 32
                height: 32
                icon.source: "qrc:/icons/like_empty.svg"
                background: Rectangle {
                    color: likeBtn.pressed ? "#e2e8f0" : "transparent"
                    radius: 16
                }
                onClicked: {
                    root.isLiked = !root.isLiked
                    root.likeClicked(root.isLiked)
                }
            }

            Button {
                id: addBtn
                width: 32
                height: 32
                icon.source: "qrc:/icons/list_add.svg"
                background: Rectangle {
                    color: addBtn.pressed ? "#e2e8f0" : "transparent"
                    radius: 16
                }
                onClicked: root.addToPlaylistClicked()
            }

            Button {
                id: favBtn
                width: 32
                height: 32
                icon.source: "qrc:/icons/collection.svg"
                background: Rectangle {
                    color: favBtn.pressed ? "#e2e8f0" : "transparent"
                    radius: 16
                }
                onClicked: {
                    root.isFavorited = !root.isFavorited
                    root.favoriteClicked(root.isFavorited)
                }
            }

            Button {
                id: delBtn
                width: 32
                height: 32
                icon.source: "qrc:/icons/delete.svg"
                background: Rectangle {
                    color: delBtn.pressed ? "#fee2e2" : "transparent"
                    radius: 16
                }
                onClicked: root.deleteClicked()
            }
        }

        // 时长
        Text {
            text: root.duration
            font.pixelSize: 12
            font.family: "monospace"
            color: "#94a3b8"
            horizontalAlignment: Text.AlignRight
            width: 45
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.NoButton
    }
}