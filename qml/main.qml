import QtQuick
import QtQuick.Controls

ApplicationWindow {
    width: 400
    height: 400
    color: "gray"
    visible: true

    Text {
        anchors.centerIn: parent
        color: 'magenta'
        font.pointSize: 20;
        text: 'yo dumfuck the tepm is 10C'
    }

    Button {
        width: 100
        height: 100
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        id: button
        text: "a buton"
    }
}
