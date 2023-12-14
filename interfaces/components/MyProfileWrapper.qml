import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Effects 6.5
import QtQuick.Layouts 6.5

Item{
    id: root

    width: 150
    height: 150

    property alias source: imagePic.source
    property bool isOnline : false
    property bool isValidate : false
    property alias maWrapper: maWrapper

    // Profile Pic Wrapper
    Rectangle {
        id: rcProfileWrapper

        width: parent.width
        height: parent.height
        color: "#ffffff"
        radius: width / 2

        // Profile Picture
        Image {
            id: imagePic

            source: "qrc:/mainLib/images/Profile_Pic_Circle.png"
            fillMode: Image.PreserveAspectFit
            width: parent.height - 10
            height: parent.width - 10
            anchors.centerIn: parent


            // Profile Image Mask
            layer.enabled: true
            layer.effect: MultiEffect {
                maskEnabled: true
                maskSource: Image {
                    id: pic_Circle
                    source: "qrc:/mainLib/images/Pic_Circle.png"
                    fillMode: Image.PreserveAspectFit
                }
            }
        }

        // User Status
        Rectangle {
            id: statusRec
            width: root.width / 4
            height: root.width / 4
            radius: width / 2
            x: parent.width - root.width / 4
            y: parent.width - root.width / 4

            Rectangle {
                anchors.centerIn: parent
                width: parent.width - 6
                height: parent.width - 6
                color: isOnline === true ? "Green" : "#BFBFBF"
                radius: width / 2
            }
        }

        // Is User Valid
        Rectangle {
            id: validRec
            width: root.width / 4
            height: root.width / 4
            radius: width / 2
            x: parent.width - root.width / 4
            y: parent.width - (parent.width - 10)
            visible: isValidate === true ? true : false

            Image {
                anchors.centerIn: parent
                width: parent.width - 6
                height: parent.width - 6
                source: "qrc:/mainLib/icons/validate.svg"
                layer.enabled: true
                layer.effect: MultiEffect {
                    colorizationColor: "#9CDCFE"
                    colorization: .5
                }
                asynchronous: true
            }
        }

        MouseArea{
            id: maWrapper

            anchors.fill: parent
        }
    }
}