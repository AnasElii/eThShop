import QtQuick 6.5
import QtQuick.Layouts 6.5
import QtQuick.Shapes 1.15

Item {
    id: root

    width: 90
    height: 90

    property alias maImageUpload: maImageUpload
    property string source: ""

    Rectangle{
        id: rcContent

        width: parent.width
        height: parent.height
        radius: 10
        color: "transparent"

        Shape {
            id: imageShape

            width: rcContent.width
            implicitHeight: rcContent.height
            z: -1

            ShapePath {
                strokeWidth: 2 // Adjust the border thickness as needed
                strokeColor: "black"
                strokeStyle: ShapePath.DashLine
                dashPattern: [4, 4] // Adjust the numbers to control the pattern


                PathLine {
                    x: rcContent.width
                    y: 0
                }

              PathLine {
                    x: rcContent.width
                    y: rcContent.height
                }

                PathLine {
                    x: 0
                    y: rcContent.height
                }

                PathLine {
                    x: 0
                    y: 0
                }
            }
        }

        Rectangle {
            id: rcHolder

            width: parent.width
            height: parent.height
            color: "#F2E7DC"

            Image{
                id: imgHolder

                width: parent.width
                source: root.source
                fillMode: Image.PreserveAspectFit
            }
        }


        MouseArea{
            id: maImageUpload

            anchors.fill: parent
        }
    }

}
