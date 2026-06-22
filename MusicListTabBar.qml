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
        spacing: 4
        padding: 8
        Repeater {
            id: tabRepeater
            model: tabBar.tabModel
            MusicListTabButton {
                text: model.text
                width: tabBar.width - 16
                height: 50

                onClicked: {
                    tabBar.setCurrentIndex(model.index)
                    tabBar.tabSelected(model.text)
                }
            }
        }
    }
    Component.onCompleted:
    {
        if (tabRepeater.count > 0) {
            let firstButton = tabRepeater.itemAt(0)
            if (firstButton) {
                firstButton.checked = true
                tabBar.tabSelected(firstButton.text)
                tabBar.setCurrentIndex(0)
            }
        }
    }

    function setTabName(index, newName) {
        if (index >= 0 && index < tabModel.count) {
            tabModel.setProperty(index, "text", newName)
        }
    }
}
