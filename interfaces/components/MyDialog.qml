import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5

Item{
    id: root
    
    anchors.fill: parent

    property Dialog dialogMessageItem : Dialog {

        anchors.centerIn: parent
        width: 300
        modal: true
        title: "Send Message To " + sellerName
        standardButtons: Dialog.Ok | Dialog.Cancel

        ColumnLayout {
            spacing: 10
            anchors{
                left: parent.left
                right: parent.right
                margins: 10
            }

            RowLayout{
                Layout.alignment: Qt.AlignHCenter

                Label {

                    text: qsTr("Product:")
                    font.pixelSize: 22
                    font.family: "Texta"

                }

                Text {

                    text: title
                    font.pixelSize: 22
                    font.family: "Texta"
                    font.styleName: "Black"

                }

            }


            Label {
                id: lbMessage

                Layout.fillWidth: true
                text: qsTr("Message:")
                font.pixelSize: 22
                font.family: "Texta"
            }

            TextArea {
                id: taMessage

                height: 200
                Layout.fillWidth: true
                placeholderText: "Write your message..."
                wrapMode: TextArea.Wrap
                font.pixelSize: 16
                color: "black"
            }
        }

        onAccepted: {
            console.log("Name: " + nameField.text)
            console.log("Email: " + emailField.text)
            dialog.close()
        }

    }

    property Dialog dialogReportItem : Dialog {

        anchors.centerIn: parent
        width: 300
        modal: true
        title: "Report The User " + sellerName
        // standardButtons: Dialog.Ok | Dialog.Cancel

        ColumnLayout {
            spacing: 10
            anchors{
                left: parent.left
                right: parent.right
                margins: 10
            }

            RowLayout{
                Layout.alignment: Qt.AlignHCenter

                Label {

                    text: qsTr("Product:")
                    font.pixelSize: 22
                    font.family: "Texta"

                }

                Text {

                    text: title
                    font.pixelSize: 22
                    font.family: "Texta"
                    font.styleName: "Black"

                }

            }

            Label {

                Layout.fillWidth: true
                text: qsTr("Report")
                font.pixelSize: 22
                font.family: "Texta"
            }

            Repeater {
                model: ["Inappropriate Content", "Spam", "Sexual Content"] // Reasons for reporting
                
                CheckBox {
                    text: modelData
                }
            }

            CheckBox {
                id: otherCheckBox

                text: "Other (Please specify)"
            }

            TextArea {
                id: otherReasonTextArea

                Layout.fillWidth: true
                height: 200
                placeholderText: "Specify other reason..."
                wrapMode: TextArea.Wrap
            }

            RowLayout {

                Layout.alignment: Qt.AlignRight
                
                Button {
                    text: "Cancel"
                    onClicked: dialogReportItem.close()
                }

                Button {
                    text: "Report and Block User"
                    onClicked: {
                        console.log("Reported reasons:")
                        for (var i = 0; i < reasonsList.count; i++) {
                            if (reasonsList.get(i).checked) {
                                console.log(reasonsList.get(i).text)
                            }
                        }
                        if (otherCheckBox.checked) {
                            console.log("Other Reason: " + otherReasonTextArea.text)
                        }

                        dialogReportItem.close()
                    }
                }
            }
            
        }

    }

    property Dialog dialogDisplayNumberItem :Dialog {
        width: 300
        // standardButtons: Dialog.Close
        title: "Phone Number"
        modal: true
        anchors.centerIn: parent

        ColumnLayout {
           spacing: 10
            anchors{
                left: parent.left
                right: parent.right
                margins: 10
            }

            Text {
                id: textToCopy
                text: sellerPhoneNumber
                font.pixelSize: 18
            }

            Button {
                text: "Copy"
                onClicked: {
                    fUserManager.copyToClipboard(sellerPhoneNumber);
                    copyDialog.close();
                }
            }
        }
    }

}
