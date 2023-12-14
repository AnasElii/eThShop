import QtQuick 6.5
import QtQuick.Controls 6.5

Item {
    id: myUserInfo

    width: 190
    height: 65

    property string userName: "user name"
    property bool isOnline: false

    function isOnlineState() {
        if (isOnline === true) {
            userStateText.text = "Online";
        } else {
            userStateText.text = "Offline";
        }
    }

    Component.onCompleted: {
        userNameText.text = userName;
        userNameLogo.text = userName[0].toUpperCase();
        isOnlineState();
    }

    Rectangle {
        id: userImageRec

        width: 65
        height: 65
        radius: width / 2
        anchors.verticalCenter: parent.verticalCenter

        color: "#69d4ee"

        Text {
            id: userNameLogo

            font {
                pixelSize: 35
                family: "Texta"
                styleName: "Bold"
            }
            anchors.centerIn: parent

            // text: qsTr("A")
            color: "#FFF"
        }

        Image {
            id: name

            width: 20
            height: 20
            anchors {
                top: parent.top
                right: parent.right
            }

            source: "qrc:/mainLib/resources/icons/validate-svgrepo-com.svg"
            fillMode: Image.PreserveAspectFit
        }
    }

    Text {
        id: userNameText

        anchors {
            left: userImageRec.right
            top: parent.top
            topMargin: 10
            leftMargin: 15
        }

        font {
            pixelSize: 25
            family: "Texta"
            styleName: "Bold"
        }
    }

    Text {
        id: userStateText

        anchors {
            left: userImageRec.right
            top: userNameText.bottom
            topMargin: 5
            leftMargin: 15
        }

        font {
            pixelSize: 15
            family: "Texta"
            styleName: "Regular"
        }

        text: qsTr("online")
    }
}
