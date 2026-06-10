import QtQuick
import QtQuick.Controls

TabButton {
    font.bold: true
    background: Rectangle{
        color: checked ? "red" : "white"
    }
    contentItem: Text
    {
        text: parent.text
        font: parent.font
        color: parent.checked ? "white" : "black"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
