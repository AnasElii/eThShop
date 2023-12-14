import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5

Item{
    id: root

    Layout.fillWidth: true
    height: mouseArea.height

    property string title : ""
    property alias source : imgIcon.source
    property alias color: txTitle.color
    property alias mouseArea : mouseArea
    MouseArea{
        id: mouseArea
        
        width: clContent.width
        height: clContent.height

        RowLayout {
            id: clContent
            
            spacing: 5

            Rectangle{
                id: rcIcon

                width: txTitle.height + 5
                height: txTitle.height + 5
                color: "transparent"

                Image {
                    id: imgIcon

                    width: parent.height
                    height: parent.height
                    source: "qrc:/mainLib/icons/notification-unread-lines.svg"
                    fillMode: Image.PreserveAspectFit
                }
            }

            Text {
                id: txTitle

                text: qsTr(title)
                font {
                    pixelSize: 20
                    family: "Texta Alt"
                    styleName: "Regular"
                }
            }
            
    }

    
    }
}