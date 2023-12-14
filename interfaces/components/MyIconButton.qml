import QtQuick 6.5
import QtQuick.Controls 6.5

Item {
    id: root

    width: 40
    height: 40

    property alias color: buttonBody.color
    property alias border: buttonBody.border
    property alias source: iconImage.source
    property int iconPadding: 20
    property alias maIconButton: maIconButton

    Control {
        id: control

        padding: 7
        anchors.fill: parent

        contentItem: Image {
            id: iconImage

            width: parent.width
            height: parent.height
            smooth: true
            source: "qrc:/mainLib/icons/back.svg"
            fillMode: Image.PreserveAspectFit
        }

        background: Rectangle {
            id: buttonBody

            anchors.fill: parent
            radius: parent.width / 2
            color: "#FFF"
            border.color: "#D2D2D2"

            MouseArea {
                id: maIconButton

                anchors.fill: parent
                hoverEnabled: true
            }
        }
    }
}
