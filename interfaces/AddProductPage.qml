import QtQuick 6.5
import Qt.labs.platform
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5
import QtQuick.Effects 6.5
import QtWebSockets
import "components"

Item {
    id: root

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.margins: 10

    // MARK: - CLEAR INPUTS
    function clearInputs() {
        clearErrorFlag();
    }

    // MARK: - CLEAR ERROR
    function clearErrorFlag() {
        tfName.placeholderTextColor = "#A09F9E";
        tfPrice.placeholderTextColor = "#A09F9E";
        // tfPromo.placeholderTextColor = "#A09F9E";
    }

    Component.onCompleted: {
        myHeader.visible = false;
        myHeader.height = 0;
        fCategoryManager.fetchCategories();

        if(isEditable === true){
            textTitle.text = qsTr("Edite Product");
            btnNext.text = qsTr("Next");
            btnNext.highlighted = true;
            tfName.text = main.updateProductInfo.name;
            tfPrice.text = main.updateProductInfo.price;
            sbPromo.value = parseInt(main.updateProductInfo.sold);
            tfDescription.text = main.updateProductInfo.description;
        }
    }

    ScrollView {
        id: svContent

        anchors.fill: parent

        contentChildren: Rectangle {
            id: background

            width: parent.width
            height: gridInput.height + 40
            anchors.centerIn: parent
            color: "#FFFFFF"
            z: -1
            radius: 10

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowBlur: 0.6
                shadowVerticalOffset: 5
                shadowOpacity: 0.5
            }

            GridLayout {
                id: gridInput

                width: parent.width - 20
                anchors.centerIn: parent
                columns: 2
                columnSpacing: 20
                rowSpacing: 20

                Text {
                    id: textTitle

                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillHeight: true
                    Layout.columnSpan: 2

                    text: qsTr("Add Product")
                    font {
                        pixelSize: 50
                        family: "Source Sans Pro"
                        styleName: "Bold"
                    }
                    color: "#000000"
                }

                MyStepBar {
                    id: stepbar

                    Layout.columnSpan: 2
                    Layout.alignment: Qt.AlignHCenter
                }

                ColumnLayout {

                    Layout.columnSpan: 2

                    Label {
                        id: lbName

                        text: qsTr("Name")
                        font.pixelSize: 25
                        font.family: "Texta"
                    }
                    TextField {
                        id: tfName

                        Layout.fillWidth: true
                        placeholderText: qsTr("name...")
                        font.pixelSize: 16
                        color: "black"

                        onEditingFinished: {
                            if (tfName.text === "") {
                                tfName.placeholderTextColor = "red";
                                return;
                            } else {
                                clearErrorFlag();
                            }
                        }
                    }
                }

                RowLayout {
                    id: rlPriceAndPromo

                    Layout.columnSpan: 2

                    ColumnLayout {
                        Label {
                            id: lbPrice

                            text: qsTr("Price (DH)")
                            font.pixelSize: 25
                            font.family: "Texta"
                        }
                        TextField {
                            id: tfPrice

                            property int decimals: 0

                            Layout.fillWidth: true
                            placeholderText: qsTr("Price ( DH )")
                            font.pixelSize: 16
                            color: "black"
                            // validator: DoubleValidator{bottom: 1; top: 100000;}

                            validator: DoubleValidator {
                                bottom: Math.min(0)
                                top:  Math.max(1000000)
                                decimals: tfPrice.decimals
                                notation: DoubleValidator.StandardNotation
                            }
                            onEditingFinished: {
                                if (tfPrice.text === "") {
                                    tfPrice.placeholderTextColor = "red";
                                    return;
                                } else {
                                    clearErrorFlag();
                                }
                            }
                        }
                    }

                    ColumnLayout {
                        Label {
                            id: lbPromo

                            text: qsTr("Promo (%)")
                            font.pixelSize: 25
                            font.family: "Texta"
                        }
                        // TextField {
                        //     id: tfPromo

                        //     Layout.fillWidth: true
                        //     placeholderText: qsTr("Promo ( % )")
                        //     font.pixelSize: 16
                        //     color: "black"
                        //     validator: RegularExpressionValidator{ regularExpression: /^([0-9]|[0-9][0-9]|100)$/ }

                        //     onEditingFinished: {
                        //         if (tfPromo.text === "") {
                        //             tfPromo.placeholderTextColor = "red";
                        //             return;
                        //         } else {
                        //             clearErrorFlag();
                        //         }
                        //     }
                        // }
                        SpinBox{
                            id: sbPromo

                            value: 0
                            from: 0
                            to: 100
                            editable: true
                            
                            stepSize: 5
                        }
                    }
                }

                ColumnLayout {

                    Layout.columnSpan: 2

                    Label {
                        id: lbDescription

                        text: qsTr("Description")
                        font.pixelSize: 25
                        font.family: "Texta"
                    }

                    TextField {
                        id: tfDescription

                        Layout.fillWidth: true
                        placeholderText: "Write your message..."
                        wrapMode: Text.WordWrap
                        inputMethodHints: Qt.ImhMultiLine
                        implicitHeight: 200
                        color: "black"
                        font {
                            pixelSize: 22
                            family: "Texta"
                            styleName: "bold"
                        }
                    }
                }

                RowLayout {
                    spacing: 5

                    Layout.columnSpan: 2
                    Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                    Layout.margins: 10

                    Button {
                        id: btnCancle

                        text: "Cancle"
                        flat: true

                        onClicked: {
                            if(main.isEditable){
                                main.isEditable = false;
                                main.updateProductInfo = [];
                                main.imageSource = [];
                            }

                            stackView.pop();
                            stackView.push("HomePage.qml");

                            // Display The Header
                            myHeader.visible = true;
                            myHeader.height = 50;
                        }
                    }

                    Button {
                        id: btnNext

                        text: "Next"
                        highlighted: true

                        onClicked: {
                            if (tfName.text !== "" && tfPrice.text !== ""){

                                main.productInfo = {
                                    'name': tfName.text,
                                    'price': tfPrice.text,
                                    'promo': sbPromo.value,
                                    'description': tfDescription.text
                                };
                                
                                stackView.push("AddProductS2Page.qml");
                            }else {
                                if (tfName.text === "") {
                                    tfName.focus = true;
                                    tfName.placeholderTextColor = "red";
                                    return;
                                }
                                if (tfPrice.text === "") {
                                    tfPrice.focus = true;
                                    tfPrice.placeholderTextColor = "red";
                                    return;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
