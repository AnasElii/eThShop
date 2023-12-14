import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5
import QtQuick.Effects 6.5

Page {
    id: loginPage

    // anchors.left: parent.left
    // anchors.right: parent.right
    // anchors.margins: 10
    title: qsTr("Login Page")
    padding: 10

    Connections {
        target: fUserManager
        function onUserChanged() {
            // MARK: fill the user variable
            main.user = fUserManager.getuserData();
            main.userID = main.user.id;
            main.profileImage = main.user.imagePath;

            // MARK: Initialize the side menu
            // sideMenu.initialize();

            // MARK: Go to the Home Page
            // stackView.pop("LoginPage.qml");
            // stackView.push("HomePage.qml");
            stackView.replace("HomePage.qml");

            // MARK: Display The Header
            // myHeader.visible = true;
            // myHeader.height = 50;
        }
    }

    Connections {
        target: fAuthManager
        function onStatusChanged() {
            var status = fAuthManager.status;
            if (status === "login : success") {
                // MARK: GET USER DATA
                fUserManager.fetchUserData(parseInt(fAuthManager.id));

                // MARK: Clear Inputs
                clearInputs();

            } else if (status === "login : error") {      
                // MARK: Display Error Flag          
                rcErrorFlag.visible = true;
                tfEmail.focus = true;
                tfEmail.color = "red";
                tfPassword.color = "red";
            } else {
                console.log("Error | Status: ", fAuthManager.status);
            }
        }
    }

    // MARK: - CLEAR INPUTS
    function clearInputs() {

        clearErrorFlag();
        tfEmail.text = "";
        tfPassword.text = "";

    }

    // MARK: - CLEAR ERROR
    function clearErrorFlag() {

        rcErrorFlag.visible = false;
        tfEmail.color = "black";
        tfPassword.color = "black";
        
    }

    Component.onCompleted: {
        // myHeader.visible = false;
        // myHeader.height = 0;
    }

    Rectangle {
        id: background

        width: loginPage.width
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
                id: textTitle

                Layout.alignment: Qt.AlignHCenter
                Layout.fillHeight: true
                Layout.columnSpan: 2

                font {
                    pixelSize: 50
                    family: "Source Sans Pro"
                    styleName: "Black"
                }

                color: "#000000"
                text: qsTr("Login")
            }

            Rectangle {
                id: rcErrorFlag

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
                id: lbUserName

                text: Qt.platform.os === 'ios' || Qt.platform.os === 'macos' ? qsTr("Username") : ''
                font.pixelSize: 22
                font.family: "Texta"
            }
            TextField {
                id: tfEmail

                Layout.fillWidth: true
                placeholderText: qsTr("Username...")
                font.pixelSize: 16
                color: "black"

                onPressed: {
                    clearErrorFlag();
                }
            }

            Label {
                id: lbPassword

                text: Qt.platform.os === 'ios' || Qt.platform.os === 'macos' ? qsTr("Password") : ''
                font.pixelSize: 22
                font.family: "Texta"
            }
            TextField {
                id: tfPassword

                Layout.fillWidth: true
                placeholderText: qsTr("Password...")
                font.pixelSize: 16
                echoMode: TextField.Password
                color: "black"

                onPressed: {
                    clearErrorFlag();
                }
            }

            Button {
                id: btnLogin

                text: "Login"
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                Layout.columnSpan: 2

                onClicked: {
                    if (tfEmail.text !== "" && tfPassword.text !== "") {
                        fAuthManager.login(tfEmail.text, tfPassword.text);
                    } else {
                        tfEmail.focus = true;
                        rcErrorFlag.visible = true;
                    }
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                Layout.columnSpan: 2
                Layout.fillWidth: true
                spacing: 5

                Text {
                    text: "By clicking"
                }
                Text {
                    id: statuText
                    text: "\"Sing UP\""
                    color: "#CE9278"

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            // Handle the button click event here
                            stackView.push("RegisterPage.qml");
                        }
                    }
                }

                Text {
                    text: "Hello World"
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                Layout.columnSpan: 2
                Layout.fillWidth: true
                spacing: 5

                Text {
                    text: "Terms of Service"
                    color: "#CE9278"
                }

                Text {

                    text: "and"
                }

                Text {
                    text: "Privacy Policy."
                    color: "#CE9278"
                }
            }
        }
    }
}
