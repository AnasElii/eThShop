import QtQuick 6.5
import Qt.labs.platform
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5
import QtQuick.Effects 6.5
import QtWebSockets
import mainLib 1.0
import "components"

Item {
    id: root

    Connections {
        target: fImageUploader

        function onReplyExecuted() {
            console.log("Reply Executed: Images Uploaded");
        }
    }

    Component.onCompleted: {
        myHeader.visible = false;
    }

    FImageUploader {
        id: fImageUploader
    }

    ColumnLayout {
        Layout.columnSpan: 2
        Layout.fillWidth: true

        Label {
            id: lbImages

            text: qsTr("Add Images")
            font.pixelSize: 25
            font.family: "Texta"
        }
        MyImageUploadItem {
            id: imageUpload

            Layout.fillWidth: true
            maImageUpload.onClicked: {
                //MARK: DESPLAY MESSAGE
                customDialogLoader.source = "components/MyCustomDialog.qml";
                customDialogLoader.item.uploadProductImagesDialog.open();

                //MARK: CLEAR ERROR FLAGS
                imageUpload.strokeColor = "black";
                imageUpload.color = "transparent";
            }
        }

        RowLayout {
            spacing: 5
            Layout.fillWidth: true

            MyImageHolder {
                id: imageHolder1

                Layout.alignment: Qt.AlignLeft
                source: main.imageSource.length >= 1 ? main.imageSource[0] : ""
            }

            MyImageHolder {
                id: imageHolder2

                Layout.alignment: Qt.AlignHCenter
                source: main.imageSource.length >= 2 ? main.imageSource[1] : ""
            }

            MyImageHolder {
                id: imageHolder3

                Layout.alignment: Qt.AlignRight
                source: main.imageSource.length >= 3 ? main.imageSource[2] : ""
            }
        }
    }

    Button {
        anchors.bottom: parent.bottom
        text: "Upload Images"

        onClicked: {
            fImageUploader.uploadImages(main.imageSource, "", 48);
        }
    }
}
