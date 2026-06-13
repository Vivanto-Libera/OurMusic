import QtQuick
import QtQuick.Controls

TabButton {
    background: Rectangle{color: checked ? "red" : "white"}
    contentItem: Text
    {
        text: parent.text
        color: parent.checked ? "white" : "black"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
