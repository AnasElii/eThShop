import QtQuick 6.5
import QtQuick.Controls 6.5

Item {

    property alias info: info
    property alias infoText: infoText
    property alias background: background
    property int tbPadding: 0
    property int lrPadding: 0

    Control {
        id: info

        topPadding: tbPadding
        bottomPadding: tbPadding
        leftPadding: lrPadding
        rightPadding: lrPadding

        contentItem: Text {
            id: infoText

            text: qsTr("W: " + width + " H: " + height)
            anchors.centerIn: parent
        }

        background: Rectangle {
            id: background

            color: "#EC8569"
            opacity: 1
        }
    }
}
