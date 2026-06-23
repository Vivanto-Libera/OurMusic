import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Container {
    id: tabBar
    property ListModel tabModel: ListModel{}

    signal tabSelected(string name)

    function addMusicList(name)
    {
        tabModel.append({"text": name})
    }

    background: Rectangle {
        color: "#ffffff"
        radius: 8
        border.color: "#e0e0e0"
        border.width: 1
    }

    contentItem: Column {
        spacing: 0
        padding: 0
        // 歌单列表（可滚动区域）
        ScrollView {
            width: parent.width
            height: parent.height-50  // 留出底部按钮空间
            clip: true
            ScrollBar.vertical.policy: ScrollBar.AsNeeded

            Column{
                spacing: 4
                padding: 8
                width: parent.width

                Repeater {
                    model: tabBar.tabModel
                    MusicListTabButton {
                        text: model.text
                        width: tabBar.width-16
                        height: 50

                        onClicked: {
                            if (model.index !== currentIndex)
                            {
                                tabBar.setCurrentIndex(model.index)
                                tabBar.tabSelected(model.text)
                            }
                        }
                    }
                }
            }
        }
        // 分割线
        Rectangle{
            width: parent.width
            height: 1
            color: "#e8e8e8"
        }
        Row{
            width: parent.width
            height: 50
            spacing: 6
            padding: 8
            // 按钮区域：创建歌单和导入歌曲
            Button {
                width: (parent.width - parent.padding * 2 - parent.spacing) / 2
                height: parent.height - 16
                flat: true
                background: Rectangle {
                    color: "#EBEBE9"
                    radius: 6
                }

                contentItem: Image {
                    source: "qrc:/icons/create.svg"
                    width: 24
                    height: 24
                    fillMode: Image.PreserveAspectFit
                    anchors.centerIn: parent
                }

                onClicked: {
                    tabBar.setCurrentIndex(model.index)
                    tabBar.tabSelected(model.text)
                    createPlaylistDialog.open()
                }
            }

            // 导入歌曲按钮
            Button {
                width: (parent.width - parent.padding * 2 - parent.spacing) / 2
                height: parent.height - 16
                flat: true

                background: Rectangle {
                    color: "#EBEBE9"
                    radius: 6
                }

                contentItem: Image {
                    source: "qrc:/icons/import.svg"
                    width: 24
                    height: 24
                    fillMode: Image.PreserveAspectFit
                    anchors.centerIn: parent
                }

                onClicked: {
                    importSongDialog.open()
                }
            }
        }
    }
    function setTabName(index, newName) {
        if (index >= 0 && index < tabModel.count) {
            tabModel.setProperty(index, "text", newName)
        }
    }
}
