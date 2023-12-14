import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5

ColumnLayout {
    id: root

    Layout.fillWidth: true

    property alias text: buttonText.text
    property alias color: buttonText.color
    property alias buttonBody: buttonBody
    property alias buttonText: buttonText
    property alias mouseArea: mouseArea
    property int padding: 20

    Rectangle {
        id: buttonBody

        Layout.fillWidth: true
        height: buttonText.height + (padding * 2)
        border.color: "#707070"
        color: "#FFF"
        radius: 20
        clip: true

        Text {
            id: buttonText

            anchors.centerIn: parent
            text: "Login"
            font {
                family: "Texta"
                pixelSize: 25
                bold: true
            }
        }

        MouseArea {
            id: mouseArea

            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                buttonBody.color = "#F2F2F2";
            }

            onExited: {
                buttonBody.color = "#FFF";
            }

            onClicked: {
                console.log("Width: " + parent.width + " Height: " + parent.height);
            }
        }
    }
}
