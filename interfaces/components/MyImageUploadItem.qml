import QtQuick 6.5
import QtQuick.Layouts 6.5
import QtQuick.Shapes 1.15

Item {
    id: root

    height: rcContent.height

    property alias maImageUpload: maImageUpload
    property alias strokeColor: spImageUpload.strokeColor
    property alias color: background.color

    Rectangle{
        id: rcContent

        width: parent.width
        implicitHeight: clContent.height
        radius: 10
        color: "transparent"

        ColumnLayout{
            id: clContent
            width: parent.width

            // Spacer
            Rectangle{
                height: 10
                Layout.fillWidth: true
                opacity: 0
            }

            // MARK: - Upload Image Icon
            Rectangle{
                width: 45
                height: 35
                color: "transparent"
                Layout.alignment: Qt.AlignHCenter

                Image{
                    width: parent.width
                    source: "qrc:/mainLib/icons/upload.svg"
                    fillMode: Image.PreserveAspectFit
                }
            }

            // MARK: - Title
            Text{
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("Upload up to 3 images")
                font{
                    family: "Texta"
                    styleName: "Bold"
                    pixelSize: 15
                }
                color: "black"
            }

            // MARK: - Subtitle

            Text {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                Layout.margins: 10
                text: qsTr("(345x255 or lager recommended, up to 1MB each)")
                font{
                    family: "Texta"
                    styleName: "Bold"
                    pixelSize: 15
                }
                wrapMode: Text.WordWrap
                color: "black"
                opacity: 0.5
            }

            // Spacer
            Rectangle{
                height: 10
                Layout.fillWidth: true
                opacity: 0
            }
        }


        Shape {
            id: imageShape

            width: rcContent.width
            implicitHeight: rcContent.height
            z: -1

            ShapePath {
                id: spImageUpload

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


        MouseArea{
            id: maImageUpload

            anchors.fill: parent

        }

        Rectangle{
            id: background
            
            anchors.fill: parent
            z: -1
            color: "transparent"
        }
    }

}
