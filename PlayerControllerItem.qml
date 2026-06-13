import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    width: 500
    height: 90

    RowLayout {
        id: rowLayout
        anchors.fill: parent
        Text {
            id: name
            text: qsTr("Name")
            font.pixelSize: 20
            Layout.preferredWidth: 55
            Layout.preferredHeight: 34
        }

        ColumnLayout {
            id: columnLayout
            Layout.fillWidth: false
            RowLayout {
                id: rowLayout0
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                layoutDirection: Qt.LeftToRight
                Layout.fillWidth: true
                Button {
                    id: like
                    icon.source: "qrc:/icons/like_empty.svg"
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
                    live: true
                    snapMode: RangeSlider.NoSnap
                    Layout.preferredWidth: 240
                    Layout.preferredHeight: 16
                }

                Text {
                    id: duration
                    text: qsTr("00:00")
                    font.pixelSize: 12
                }
            }
        }

        Button {
            id: collect
            icon.source: "qrc:/icons/collection.svg"
        }

        Button {
            id: volume
            icon.source: "qrc:/icons/volume.svg"
        }

        Button {
            id: music_menu
            icon.source: "qrc:/icons/music_menu.svg"
        }
    }
}
