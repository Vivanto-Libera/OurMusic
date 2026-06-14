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
    contentItem: Column {
        spacing: 4
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
