import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5

Item{
    id: root

    Component.onCompleted: {

        myHeader.isHomePage = false;
        myHeader.text = "Edit"
    
    }

    ColumnLayout
    {
        id: clUsername

        TextField {
            id: tfUsername

            Layout.fillWidth: true
            Layout.columnSpan: 2
            Layout.margins: 10
            placeholderText: qsTr("Search...")
            font.pixelSize: 16
            color: "black"
        }
    }
}