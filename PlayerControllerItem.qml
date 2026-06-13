import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: rectangle
    width: 500
    height: 90
    border
    {
        color: "black"
        width: 1
    }

    Text {
        id: name
        text: qsTr("Name")
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: columnLayout.left
        font.pixelSize: 20
        horizontalAlignment: Text.AlignHCenter
        Layout.preferredWidth: 55
        Layout.preferredHeight: 34
    }

    ColumnLayout {
        id: columnLayout
        anchors.centerIn: parent
        RowLayout {
            id: rowLayout0
            layoutDirection: Qt.LeftToRight
            Button {
                id: like
                icon.source: checked ? "qrc:/icons/like_red.svg" : "qrc:/icons/like_empty.svg"
                checkable: true
                Layout.preferredWidth: 30
                Layout.preferredHeight: 39
            }

            Button {
                id: previous
                icon.source: "qrc:/icons/next.svg"
            }

            Button {
                id: roundButton
                icon.source: "qrc:/icons/play.svg"
                background: Rectangle {
                    color: "#ff0000"
                    radius: width / 2
                }
            }

            Button {
                id: next
                icon.source: "qrc:/icons/previous.svg"
            }

            Button {
                id: loop_mode
                icon.source: "qrc:/icons/play_cycle.svg"
            }
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }

        RowLayout {
            id: rowLayout1
            Text {
                id: position
                text: qsTr("00:00")
                font.pixelSize: 12
            }

            Slider {
                id: slider
                width: 240
                value: 0.5
                snapMode: RangeSlider.NoSnap
                live: true
                Layout.preferredWidth: 240
                Layout.preferredHeight: 16
            }

            Text {
                id: duration
                text: qsTr("00:00")
                font.pixelSize: 12
            }
        }
        Layout.fillWidth: false
    }

    RowLayout {
        id: rowLayout
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.left: columnLayout.right
        Button {
            id: collect
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            icon.source: "qrc:/icons/collection.svg"
        }

        Button {
            id: volume
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            icon.source: "qrc:/icons/volume.svg"
        }

        Button {
            id: music_menu
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            icon.source: "qrc:/icons/music_menu.svg"
        }
    }
}
