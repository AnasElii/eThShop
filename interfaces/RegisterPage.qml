import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5
import QtQuick.Effects 6.5

Item {
    id: root

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.margins: 10

    Connections{
        target: fUserManager
        function onUserChanged(){
            // fill the user variable
            main.user = fUserManager.userData();
            main.userID = user.id;

            // Switch Pages
            stackView.push("TypePage.qml")
        }
    }

    Connections{
        target: fAuthManager
        function onStatusChanged(){

            var status =  fAuthManager.status;
            if(status === "register : success"){
                fUserManager.getUser(parseInt(fAuthManager.id));

                //MARK: CLEAR INPUTS
                clearInputs();

            } else if ( status === "register : error" ){
                
                console.log("Status: ", fAuthManager.status)
                rcErrorFlag.visible = true;
                tfEmail.focus = true;
                tfEmail.color = "red";
                tfPassword.color = "red";
            
            }
            else{

                console.log("Error | Status: ", fAuthManager.status)
            }
        }
    }

    // MARK: - CLEAR INPUTS
    function clearInputs(){
        rcErrorFlag.visible= false;
        tfUsername.color = "black";
        tfEmail.color= "black";
        tfPhoneNumber.color = "black";
        tfPassword.color= "black";
    }

    Component.onCompleted:{

        myHeader.visible = false;
        myHeader.height= 0;
        
    } 

    Rectangle {
        id: background

        width: root.width
        height: gridInput.height + 40
        anchors.centerIn: parent
        color: "#FFFFFF"
        z: -1
        radius: 10

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowBlur: .6
            shadowVerticalOffset: 5
            shadowOpacity: .5
        }

        GridLayout {
            id: gridInput

            width: parent.width - 20
            anchors.centerIn: parent
            columns: 2
            columnSpacing: 20
            rowSpacing: 20

            Text {
                id: txtTitle
                
                Layout.alignment: Qt.AlignHCenter
                Layout.fillHeight: true
                Layout.columnSpan: 2

                text: qsTr("Register")
                font {
                    pixelSize: 50
                    family: "Source Sans Pro"
                    styleName: "Black"
                }
                color: "#000000"
            }

            // MARK: - ERROR MESSAGE
            Rectangle{
                id: rcErrorFlag

                property alias text : txErrorText.text

                Layout.alignment: Qt.AlignHCenter
                Layout.columnSpan: 2
                implicitHeight: txErrorText.height + 10
                implicitWidth: txErrorText.width + 10
                visible: false
                color: "red"
                opacity: 0.5

                Text {
                    id: txErrorText
                    
                    anchors.centerIn: parent
                    text: qsTr("Username or Password incorrect")
                    font {
                        pixelSize: 20
                        family: "Source Sans Pro"
                        styleName: "Black"
                    }
                    color: "#000000"
                }
            }

            Label {
                text: qsTr("Username")
                font.pixelSize: 22
                font.family: "Texta"
            }
            TextField {
                id: tfUsername

                Layout.fillWidth: true
                placeholderText: qsTr("Username...")
                font.pixelSize: 16
                color: "black"

                onPressed:{
                    clearInputs();
                }
            }

            Label {
                text: qsTr("Email")
                font.pixelSize: 22
                font.family: "Texta"
            }
            TextField {
                id: tfEmail

                Layout.fillWidth: true
                placeholderText: qsTr("Email...")
                font.pixelSize: 16
                color: "black"

                onPressed:{
                    clearInputs();
                }
            }

            Label {
                text: qsTr("Tel")
                font.pixelSize: 22
                font.family: "Texta"
            }
            TextField {
                id: tfPhoneNumber

                Layout.fillWidth: true
                placeholderText: qsTr("teleph...")
                font.pixelSize: 16
                color: "black"

                onPressed:{
                    clearInputs();
                }
            }

            Label {
                text: qsTr("Password")
                font.pixelSize: 22
                font.family: "Texta"
            }
            TextField {
                id: tfPassword

                Layout.fillWidth: true
                placeholderText: qsTr("Password...")
                font.pixelSize: 16
                color: "black"
                echoMode: TextField.Password

                onPressed:{
                    clearInputs();
                }
            }

            Button {
                id: btnRegister
                    
                text: qsTr("Register") 
                Layout.fillWidth: true           
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                Layout.columnSpan: 2

                onClicked: {
                    if (tfUsername.text !== "" && tfEmail.text !== "" && tfPhoneNumber.text !== "" && tfPassword.text !== "")
                        fAuthManager.singup(tfUsername.text, tfEmail.text, tfPhoneNumber.text, tfPassword.text);
                    else {
                        rcErrorFlag.text = "Error";
                        rcErrorFlag.visible = true;
                        console.log("Login failed");                   
                        if(tfUsername.text === "")
                        {
                            tfUsername.focus = true;
                            tfUsername.color = "red";
                        }
                        
                        if(tfEmail.text === "")
                        {
                            tfEmail.focus = true;
                            tfEmail.color = "red";
                        }

                        if(tfPhoneNumber.text === "")
                        {
                            tfPhoneNumber.focus = true;
                            tfPhoneNumber.color = "red";
                        }

                        if(tfPassword.text === "")
                        {
                            tfPassword.focus = true;
                            tfPassword.color = "red";
                        }
                    }
                }
            }

            RowLayout{
                Layout.alignment: Qt.AlignHCenter 
                Layout.columnSpan: 2
                Layout.fillWidth: true
                spacing: 5   
        
                Text {
                    text: qsTr("you have an acount")
                    font.pixelSize: 12
                }

                Text {
                    id: statuText
                    text: "\"Login\""
                    color: "#CE9278"
                        
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            // Handle the button click event here
                            console.log("Login")
                            stackView.push("LoginPage.qml")
                        }            
                    }
                }
            }
        }
    }
}
