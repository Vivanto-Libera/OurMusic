import QtQuick
import QtQuick.Controls

Window {
    width: 360
    height: 640
    visible: true
    title: qsTr("音乐播放器")
    color: "#f5f5f5"

    Column {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            width: parent.width
            height: 50
            color: "#d43c33"

            Row {
                anchors.fill: parent
                spacing: 0

                Text {
                    width: parent.width / 3
                    text: "推荐"
                    color: "#ffffff"
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    width: parent.width / 3
                    text: "播放器"
                    color: "#ffffff"
                    font.pixelSize: 16
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    width: parent.width / 3
                    text: "我的"
                    color: "#ffffff"
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 4
            color: "#c20c0c"
        }

        Rectangle {
            width: parent.width
            height: 486
            color: "#f5f5f5"

            Column {
                anchors.centerIn: parent
                spacing: 15

                Rectangle {
                    width: 280
                    height: 280
                    color: "#e0e0e0"
                    radius: 8

                    Text {
                        anchors.centerIn: parent
                        text: "专辑封面"
                        color: "#999999"
                        font.pixelSize: 16
                    }
                }

                Text {
                    text: "歌曲名称"
                    color: "#333333"
                    font.pixelSize: 18
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                }

                Text {
                    text: "歌手名称"
                    color: "#666666"
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                }

                Text {
                    text: "专辑名称"
                    color: "#999999"
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 100
            color: "#ffffff"

            Column {
                anchors.fill: parent
                padding: 8
                spacing: 5

                Row {
                    width: parent.width
                    spacing: 10

                    Text {
                        text: "0:00"
                        color: "#666666"
                        font.pixelSize: 11
                        width: 35
                        verticalAlignment: Text.AlignVCenter
                    }

                    Slider {
                        id: progressSlider
                        width: parent.width - 70
                        value: 0.3
                        from: 0
                        to: 1
                        stepSize: 0.01

                        background: Rectangle {
                            color: "#e0e0e0"
                            height: 4
                            radius: 2
                        }

                        handle: Rectangle {
                            color: "#d43c33"
                            width: 10
                            height: 10
                            radius: 5
                            anchors.centerIn: parent
                        }
                    }

                    Text {
                        text: "3:45"
                        color: "#666666"
                        font.pixelSize: 11
                        width: 35
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Row {
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 35

                    Text {
                        text: "♥"
                        color: "#666666"
                        font.pixelSize: 22
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: "<<"
                        color: "#333333"
                        font.pixelSize: 22
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Rectangle {
                        width: 50
                        height: 50
                        color: "#d43c33"
                        radius: 25

                        Text {
                            anchors.centerIn: parent
                            text: ">"
                            color: "#ffffff"
                            font.pixelSize: 24
                            font.bold: true
                        }
                    }

                    Text {
                        text: ">>"
                        color: "#333333"
                        font.pixelSize: 22
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: "☰"
                        color: "#666666"
                        font.pixelSize: 22
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}