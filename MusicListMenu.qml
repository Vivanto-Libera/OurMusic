import QtQuick
import QtQuick.Controls

Item {
    id: root
    property ListModel songModel: ListModel{}
    Text {
        id: name
        text: qsTr("Name")
        anchors.top: parent.top
        font.pixelSize: 24
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Button {
        id: edit
        anchors.verticalCenter: name.verticalCenter
        anchors.left: name.right
        anchors.leftMargin: 10
        icon.source: "icons/edit.svg"
    }

    ListView {
        id: listView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: name.bottom
        anchors.bottom: parent.bottom
        Repeater {
            model: root.songModel
        }
    }

}
