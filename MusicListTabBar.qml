import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Container {
    id: tabBar
    property ListModel tabModel: ListModel{}
    function addMusicList(name)
    {
        tabModel.append({"text": name})
    }

    // 美化：背景圆角、边距
    background: Rectangle {
        color: "#ffffff"
        radius: 8
        border.color: "#e0e0e0"
        border.width: 1
    }

    contentItem: Column {
        spacing: 4
        padding: 8
        Repeater {
            model: tabBar.tabModel
            MusicListTabButton {
                text: model.text
                width: tabBar.width - 16  // 减去左右padding
                height: 50
            }
        }
    }

    function setTabName(index, newName) {
        if (index >= 0 && index < tabModel.count) {
            tabModel.setProperty(index, "text", newName)
        }
    }
}
