import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Container {
    id: tabBar
    function addMusicList(name)
    {
        tabModel.append({"text": name})
    }
    property ListModel tabModel: ListModel{}

    contentItem: Column {
        spacing: 2
        Repeater {
            model: tabBar.tabModel
            MusicListTabButton {
                text: model.text
                width: tabBar.width
                height: tabBar.width / 3
            }
        }
    }
}
