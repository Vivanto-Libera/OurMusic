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

    // 左侧歌曲名称 - 向右移动（增加左边距）
    Text {
        id: name
        text: qsTr("Name")
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
            }

            Button {
                id: previous
                icon.source: "qrc:/icons/next.svg"
                flat: true
                icon.width: 28
                icon.height: 28
                implicitWidth: 46
                implicitHeight: 46
            }

            Button {
                id: roundButton
                icon.source: "qrc:/icons/play.svg"
                icon.width: 32
                icon.height: 32
                background: Rectangle {
                    color: "#e84c3d"
                    radius: width / 2
                }
                implicitWidth: 54
                implicitHeight: 54
            }

            Button {
                id: next
                icon.source: "qrc:/icons/previous.svg"
                flat: true
                icon.width: 28
                icon.height: 28
                implicitWidth: 46
                implicitHeight: 46
            }

            Button {
                id: loop_mode
                icon.source: "qrc:/icons/play_cycle.svg"
                flat: true
                icon.width: 26
                icon.height: 26
                implicitWidth: 42
                implicitHeight: 42
            }

            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }

        RowLayout {
            id: rowLayout1
            spacing: 10

            Text {
                id: position
                text: qsTr("00:00")
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
                text: qsTr("00:00")
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
        }

        Button {
            id: music_menu
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            icon.source: "qrc:/icons/music_menu.svg"
            flat: true
            icon.width: 24
            icon.height: 24
            implicitWidth: 40
            implicitHeight: 40
        }
    }
}
