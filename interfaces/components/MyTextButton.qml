import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5

Item{
    id: root

    height: clContent.height

    property string title : ""
    property alias color: txTitle.color
    property alias txSubTitle : txSubTitle
    property string subTitle : "Tap to change the Username"
    property alias mouseArea : mouseArea
    MouseArea{
        id: mouseArea

        height: clContent.height
        width: clContent.width
        
        ColumnLayout {
            id: clContent
            
            spacing: 5
            Text {
                id: txTitle

                Layout.fillWidth: true
                text: title
                font {
                    pixelSize: 20
                    family: "Texta Alt"
                    styleName: "Regular"
                }
            }

            Text {
                id: txSubTitle

                Layout.fillWidth: true
                visible : true
                text: qsTr(subTitle)
                font {
                    pixelSize: 20
                    family: "Texta Alt"
                    styleName: "Light"
                }
            }

            
        }
    }
}