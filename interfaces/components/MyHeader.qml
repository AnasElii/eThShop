import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5

Item{
    id: root

    width: parent.width
    visible : root.isVisible
    height: 50

    property string leftSource: imgCustomIconLeft.source
    property alias color : background.color
    property alias text: txTitle.text
    property bool isHomePage: false
    property bool isNotification : false
    property alias maLeft : maLeft
    property bool isVisible : true
    property alias maNotificationRight : maNotificationRight
    property alias maSearchRight : maSearchRight

    RowLayout{
        id: rlContent

        width: root.width
        height: root.height

        // Home & Return Icon Button
        Rectangle{
            id: rcCustomButtonLeft

            width: 50
            height: parent.height
            Layout.alignment : Qt.AlignLeft
            color: "transparent"

            Image{
                id: imgCustomIconLeft

                width: parent.width - 10
                height: parent.width - 10
                anchors.centerIn: parent
                source: isHomePage === true ? "qrc:/mainLib/icons/menu-hamburger.svg" : "qrc:/mainLib/icons/back.svg" 
                fillMode: Image.PreserveAspectFit
            }

            MouseArea{
                id: maLeft

                anchors.fill: parent
            }

        }

        // Title & Info
        Text{
            id: txTitle
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            text: "Tiflet Store"
            font{
                pixelSize: 25
                family: "Texta"
                styleName: "Black"
            }
        }

        // Notification & Search
        RowLayout{
            id: rlLeftIcons
            
            Layout.alignment : Qt.AlignRight
            height: parent.height

            //Notification
            Rectangle{
                id: rcNotificationButtonRight

                width: 50
                height: parent.height
                color: "transparent"
                visible: false

                Image{
                    id: imgNotificationIconRight

                    width: parent.width - 10
                    height: parent.width - 10
                    anchors.centerIn: parent
                    source: isNotification === true ? "qrc:/mainLib/icons/notification_active.svg" : "qrc:/mainLib/icons/notification.svg";
                    fillMode: Image.PreserveAspectFit
                }

                MouseArea{
                    id: maNotificationRight

                    anchors.fill: parent
                }
            }

            // Search
            Rectangle{
                id: rcSearchButtonRight

                width: 50
                height: parent.height
                color: "transparent"

                Image{
                    id: imgSearchIconRight

                    width: parent.width - 10
                    height: parent.width - 10
                    anchors.centerIn: parent
                    source: "qrc:/mainLib/icons/search.svg"
                    fillMode: Image.PreserveAspectFit
                }

                MouseArea{
                    id: maSearchRight

                    anchors.fill: parent
                }
            }

        }

    }

    Rectangle{
        id: background

        anchors.fill: parent
        z: -1
    }
}
