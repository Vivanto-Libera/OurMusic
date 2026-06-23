import QtQuick
import QtQuick.Controls
import OurMusic

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
    property string url

    signal playClicked()
    signal editClicked()
    signal likeClicked(bool liked)
    signal addToPlaylistClicked()
    signal deleteClicked()
    signal collected()

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
            icon.source: "qrc:/icons/play_black.svg"
            background: Rectangle {
                color: playBtn.pressed ? "#e2e8f0" : "#f1f5f9"
                radius: 18
            }
            onClicked: root.playClicked()
            // 添加悬停文本提示
            ToolTip{
                visible: playBtn.hovered
                text: "播放当前歌曲"
                delay: 500
            }
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
                icon.source: checked ? "qrc:/icons/like_red.svg" : "qrc:/icons/like_empty.svg"
                checkable: true
                background: Rectangle {
                    color: likeBtn.pressed ? "#e2e8f0" : "transparent"
                    radius: 16
                }
                onClicked: {
                    root.isLiked = likeBtn.checked
                    root.likeClicked(root.isLiked)
                    SongBroker.singleton().setSongLiked(url, root.isLiked)
                }
                // 添加悬停文本提示
                ToolTip{
                    visible: likeBtn.hovered
                    text: "喜欢"
                    delay: 500
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
                // 添加悬停文本提示
                ToolTip{
                    visible: addBtn.hovered
                    text: "添加至播放列表"
                    delay: 500
                }
            }

            Button {
                id: clecBtn
                width: 32
                height: 32
                icon.source: "qrc:/icons/collection.svg"
                background: Rectangle {
                    color: clecBtn.pressed ? "#e2e8f0" : "transparent"
                    radius: 16
                }
                onClicked: {
                    root.collected()
                }
                // 添加悬停文本提示
                ToolTip{
                    visible: clecBtn.hovered
                    text: "收藏"
                    delay: 500
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
                // 添加悬停文本提示
                ToolTip{
                    visible: delBtn.hovered
                    text: "删除"
                    delay: 500
                }
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

    TapHandler {
        id: mouseArea
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.NoButton
    }
    Component.onCompleted:
    {
        likeBtn.checked = isLiked
    }
}
