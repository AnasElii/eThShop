import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5

Item {
    id: root

    Layout.alignment: Qt.AlignRight

    height: 30
    width: 85

    property alias text: titleText.text
    property alias source: imgCustomIcon.source

    RowLayout{
        id: rlContent

        height: root.height

        Rectangle{
            id: rcIcon

            width: 30
            height: 30
            color: "transparent"

            Image {
                id: imgCustomIcon

                anchors.fill: parent
                source: "qrc:/mainLib/icons/location.svg"
                fillMode: Image.PreserveAspectFit
            }
        }

        Text{
            id: titleText

            font{
                pixelSize: 20
                family: "Texta"
            }

            text: qsTr("Tiflet")
        }

        Rectangle{
            width: 5
            height: parent.height
            opacity: 0
        }
    }

}
