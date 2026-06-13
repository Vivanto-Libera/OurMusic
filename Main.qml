import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    width: 1080
    height: 640
    visible: true
    title: qsTr("音乐播放器")
    color: "#f5f5f5"

    ColumnLayout {
        id: columnLayout
        anchors.fill: parent
        TabBar {
            id: tabBar
            Layout.fillWidth: true
            MainTabButton {
                id: allSongs
                x: 9
                y: 28
                text: qsTr("全部歌曲")
            }

            MainTabButton {
                id: songDetail
                text: qsTr("歌曲详细")
            }

            MainTabButton {
                id: myCollection
                text: qsTr("我的收藏")
            }
            Layout.preferredWidth: 266
            Layout.preferredHeight: 44
        }

        StackView {
            id: stackView
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.preferredWidth: 200
            Layout.preferredHeight: 200

            PlayerControllerItem {
                id: playerControllerItem
                y: 501
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
