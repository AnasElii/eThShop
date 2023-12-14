import QtQuick 6.5
import QtQuick.Layouts 6.5

Item {
    id: root

    width: 125
    height: 40

    property int step: 1

    RowLayout{
        width: root.width
        height: root.height
        spacing: 0

        Rectangle{
            Layout.alignment: Qt.AlignLeft
            width: 40
            height: 40

            color: "#FFD688"
            radius: width/2

            // Circle Insdie Circle Rectangle
            Rectangle{
                visible: root.step === 1 ? true : false
                width: 25
                height: 25
                anchors.centerIn: parent

                color: "#FFD688"
                radius: width/2
                border.color: "#FFF"
                border.width: 5
            }

            // Image Rectangle
            Rectangle{
                visible: root.step === 1 ? false : true
                width: 30
                height: 30
                anchors.centerIn: parent
                color: "transparent"

                Image{
                    id: imgIcon

                    visible: true
                    width: parent.width
                    source: "qrc:/mainLib/icons/verified.svg"
                    fillMode: Image.PreserveAspectFit
                }

            }
        }

        Rectangle{
            Layout.fillWidth: true
            height: 2
            color: root.step === 1 ? "#9CA3AF" : "#FFD688"
        }

        Rectangle{
            Layout.alignment: Qt.AlignRight
            width: 40
            height: 40

            color: step === 1 ? "#9CA3AF" : "#FFD688"
            radius: width/2

            Rectangle{
                visible: true
                width: 30
                height: 30
                anchors.centerIn: parent

                color: "#FFF"
                radius: width/2
            }
            // Circle Insdie Circle Rectangle
            Rectangle{
                visible: root.step === 1 ? false : true
                width: 25
                height: 25
                anchors.centerIn: parent

                color: "#FFD688"
                radius: width/2
                border.color: "#FFF"
                border.width: 5
            }
        }
    }
}
