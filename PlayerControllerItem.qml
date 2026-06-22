import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

Rectangle {
    id: rectangle
    width: 500
    height: 105
    color: "#ffffff"
    radius: 12
    border.color: "#dddddd"
    border.width: 1

    // 播放模式枚举
    property int playMode: 0

    // 播放列表
    property ListModel playlistModel: ListModel{}
    // 添加歌曲到播放列表
    function addToPlaylist(songName){
        playlistModel.append({"songName" : songName})
    }

    // 左侧歌曲名称 - 向右移动
    Text {
        id: name
        text: "Name"
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
                // 添加悬停文本提示
                ToolTip{
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
                // 添加悬停文本提示
                ToolTip{
                    visible: previous.hovered
                    text: "上一曲"
                    delay: 500
                }
            }

            Button {
                id: play
                icon.source: "qrc:/icons/play.svg"
                icon.width: 32
                icon.height: 32
                background: Rectangle {
                    color: "#e84c3d"
                    radius: width / 2
                }
                implicitWidth: 54
                implicitHeight: 54
                // 添加悬停文本提示
                ToolTip{
                    visible: play.hovered
                    text: "播放/暂停"
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
                // 添加悬停文本提示
                ToolTip{
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
                // 根据不同的playMode变换图标, 0对应循环播放, 1对应单曲循环, 2对应随机播放
                icon.source: {
                    switch(playMode){
                        case 0: return "qrc:/icons/play_cycle.svg"
                        case 1: return "qrc:/icons/play_once.svg"
                        case 2: return "qrc:/icons/random.svg"
                    }
                }
                // 点击图标切换playMode
                onClicked: {
                    playMode = (playMode + 1)%3
                    loop_mode.modeChanged(playMode)
                }
                signal modeChanged(int mode)

                // 指针悬停显示当前playMode
                ToolTip{
                    visible: loop_mode.hovered
                    text: {
                        switch(playMode){
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
                value: 0.5
                snapMode: RangeSlider.NoSnap
                live: true
                Layout.preferredWidth: 260
                Layout.preferredHeight: 16
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
            // 添加悬停文本提示
            ToolTip{
                visible: collect.hovered
                text: "收藏"
                delay: 500
            }
        }

        // ===== 音量按钮（带竖向滑块 + 数字显示，颜色改为黑色） =====
        Button {
            id: volume
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            icon.source: "qrc:/icons/volume.svg"
            flat: true
            icon.width: 24
            icon.height: 24
            implicitWidth: 40
            implicitHeight: 40

            onClicked: volumePopup.open()

            Popup {
                id: volumePopup
                x: volume.width - width/2
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

                    // 显示音量数值（0～100）
                    Text {
                        id: volumeValueText
                        text: Math.round(volumeSlider.value * 100)
                        font.pixelSize: 14
                        font.bold: true
                        color: "#000000"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    // 竖向滑块【已修复】
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

                            // 修改1：填充条顶部锚定，高度反向计算，和圆点同步
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
                            // 修改2：对标水平Slider官方写法，用slider原生padding/available尺寸计算y
                            x: (volumeSlider.availableWidth - width) / 2
                            y: volumeSlider.topPadding + (volumeSlider.availableHeight - height) * volumeSlider.visualPosition
                        }
                    }
                }
            }
            // 添加悬停文本提示
            ToolTip{
                visible: volume.hovered
                text: "音量大小"
                delay: 500
            }
        }
        // 播放列表按钮
        Button {
            id: music_menu
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            icon.source: "qrc:/icons/music_menu.svg"
            flat: true
            icon.width: 24
            icon.height: 24
            implicitWidth: 40
            implicitHeight: 40
            // 添加悬停文本提示
            ToolTip{
                visible: music_menu.hovered
                text: "播放列表"
                delay: 500
            }
            onClicked: playlistDialog.open()
        }
    }
    // 点击播放列表弹出的对话框
    Dialog{
        id: playlistDialog
        title: ""
        modal: true
        z: 10
        x: parent.width - width - 10
        y: -height - 10
        width: 200
        height: 300

        // 自定义标题栏
        header: Rectangle {
            height: 50
            color: "#f5f5f5"
            clip: true

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                // 标题文本
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

        contentItem: ColumnLayout{
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: playListText.bottom
            anchors.margins: 8
            // 列表显示区域
            ListView{
                id: playlistListView
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: playlistModel

                delegate: Rectangle{
                    width: playlistListView.width
                    height: 40
                    color: index % 2 === 0 ? "#f8f8f8" : "white"

                    RowLayout{
                        anchors.fill: parent
                        anchors.margins: 4
                        spacing: 8
                        // 歌曲名称
                        Text{
                            text: model.songName
                            anchors.left: parent.left
                            anchors.leftMargin: 12
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 14
                        }
                        // 按钮：从列表中删除
                        Button{
                            id: delBtn
                            anchors.right: parent.right
                            icon.source: "qrc:/icons/delete.svg"
                            background: Rectangle{
                                color: "transparent"
                            }
                            onClicked: {
                                playlistModel.remove(index)
                            }
                        }
                    }
                }
            }
        }
    }
    Component.onCompleted: {
        // 添加测试歌曲到播放列表
        playlistModel.append({"songName": "起风了"})
        playlistModel.append({"songName": "稻香"})
        playlistModel.append({"songName": "晴天"})
        playlistModel.append({"songName": "夜曲"})
        playlistModel.append({"songName": "七里香"})
    }
}