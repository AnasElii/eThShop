import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    width: 20
    height: 20

    property alias color : activeRec.color
    property string borderColor : mainrec.border.color
    property bool isActive: false

    Rectangle{
        id: mainrec

        color: "transparent"
        anchors.fill: parent
        radius: 15
        border.color: "#707070"
        border.width: 2

        Rectangle{
            id: activeRec

            color: "#707070"
            visible: isActive
            anchors.fill: parent
            radius: 15
            anchors.margins: 3
        }

    }
}
