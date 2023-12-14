import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Effects 6.5
import QtQuick.Layouts 6.5
import QtQuick.Dialogs 6.5
import mainLib 1.0
import "components"

Item {
    id: root

    property int id
    property string username: ""
    property string email: ""
    property string tel: ""
    property bool isOnline: false
    property bool isValidate: false
    property string feild : ""

    Connections{
        target: fUserManager

        function onUserChanged(){
            
            // Filling User Data
            root.id = main.user.id
            root.username = main.user.username
            root.email = main.user.email
            root.tel = main.user.tel
            root.isValidate = main.user.valid
            root.isOnline = true
        }

        function onUserUpdated(feild, newData){
            console.log("The " + feild + ": " + newData);
        }
    }
    
    Component.onCompleted:{
        
        initialize();
        myHeader.isHomePage = false;
        myHeader.text = "Settings"

    }

    function initialize(){
        // fUserManager.getUser(main.userID);
        root.id = main.user.id
        root.username = main.user.username
        root.email = main.user.email
        root.tel = main.user.tel
        root.isValidate = main.user.valid
        root.isOnline = true
    }

    ScrollView {
       anchors.fill: parent
       anchors.margins: 10

        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff  

        ColumnLayout {
            id: clContent

            width: root.width
            spacing: 10

            // Header
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                // Profile Pic Wrapper
                MyProfileWrapper{
                    id: profileWrapper

                    source: fUserManager.getImageUrl()
                    isOnline: root.isOnline 
                    isValidate : root.isValidate
                }

                // Title
                ColumnLayout {
                    spacing: 10
                    Layout.alignment: Qt.AlignCenter

                    Text {
                        id: tfUserName

                        Layout.fillWidth: true
                        text: username
                        font {
                            pixelSize: 25
                            family: "Texta"
                            styleName: "Black"
                        }
                    }
                }
            }
            
            // Change profile image
            Rectangle {
                Layout.fillWidth: true
                height: icon.height
                color: "transparent"

                Rectangle {
                    width: parent.width
                    height: 2
                    color: "black"
                    opacity: 0.5
                    anchors.verticalCenter: parent.verticalCenter
                }

                Image {
                    id: icon

                    width: 50
                    height: 50
                    source: "qrc:/mainLib/icons/Icon.png"
                    fillMode: Image.PreserveAspectFit
                    anchors.right: parent.right
                    anchors.rightMargin: 40

                    MouseArea{
                        anchors.fill: parent
                        onClicked:{
                            stackView.push("ProfileImagePage.qml")
                        }
                    }
                }
            }

            // Account Info
            Text {
                Layout.fillWidth: true
                text: qsTr("Account")
                font {
                    pixelSize: 25
                    family: "Texta"
                    styleName: "Black"
                }
            }

            // Update Username
            MyTextButton{
                id: mtbUsernameButton

                title: username

                mouseArea.onClicked:{
                    root.feild = "username";
                    dialog.visible = true;
                    console.log("Name Changsed");
                }   
            }

            // Update Email
            MyTextButton{
                id: mtbEmailButton

                title: email
                subTitle: "Tap to change the Email"

                mouseArea.onClicked:{
                    root.feild = "email";
                    dialog.visible = true;
                    console.log("email Changsed");
                }   
            }

            // Update Phone Number
            MyTextButton{
                id: mtbTelButton

                title: tel
                subTitle: "Tap to change the Phone number"

                mouseArea.onClicked:{
                    root.feild = "tel";
                    dialog.visible = true;
                    console.log("phone number Changsed");
                }   
            }

            // Update Password
            MyTextButton{
                id: mtbPasswordButton

                title: "Password"
                subTitle: "Tap to change the Password"

                mouseArea.onClicked:{
                    root.feild = "password"
                    dialogPassword.visible = true
                    console.log("Password Changed")
                } 
            }

            // General Settings
            Rectangle {
                Layout.fillWidth: true
                height: 2
                color: "black"
                opacity: 0.5
            }

            // whitet space
            Rectangle{
                Layout.fillWidth: true
                height: 10
                opacity: 0
            }

            Text {
                Layout.fillWidth: true
                text: qsTr("Settings")
                font {
                    pixelSize: 25
                    family: "Texta"
                    styleName: "Black"
                }
            }

            MyIconTextButton{
                title: "Notification and Sounds"
                source: "qrc:/mainLib/icons/notification-unread-lines.svg"
                
                mouseArea.onClicked:{
                    console.log("Notification Settings")
                }
            }

            MyIconTextButton{
                title: "Privacy and Security"
                source: "qrc:/mainLib/icons/shield-user.svg"
                
                mouseArea.onClicked:{
                    console.log("Privacy and Security Page")
                }
            }

            MyIconTextButton{
                title: "Language"
                source: "qrc:/mainLib/icons/shield-network.svg"
                
                mouseArea.onClicked:{
                    console.log("Change Language")
                }
            }

            // Help Settings
            Rectangle {
                Layout.fillWidth: true
                height: 2
                color: "black"
                opacity: 0.5
            }

            // whitet space
            Rectangle{
                Layout.fillWidth: true
                height: 10
                opacity: 0
            }

            Text {
                Layout.fillWidth: true
                text: qsTr("Help")
                font {
                    pixelSize: 25
                    family: "Texta"
                    styleName: "Black"
                }
            }

            MyIconTextButton{
                title: "Ask a Question"
                source: "qrc:/mainLib/icons/message-circle-question.svg"
                
                mouseArea.onClicked:{
                    console.log("Ask a Question")
                }
            }

            MyIconTextButton{
                title: "Contact Support"
                source: "qrc:/mainLib/icons/users.svg"
                
                mouseArea.onClicked:{
                    console.log("Support Contacted")
                }
            }

            MyIconTextButton{
                title: "Tiflet Store FAQ"
                source: "qrc:/mainLib/icons/question-square.svg"
                
                mouseArea.onClicked:{
                    console.log("Tiflet Store FAQ")
                }
            }

            MyIconTextButton{
                title: "Privacy Policy"
                source: "qrc:/mainLib/icons/privacy-dashboard.svg"
                
                mouseArea.onClicked:{
                    console.log("Privacy Policy")
                }
            }

            // Connection
            Rectangle {
                Layout.fillWidth: true
                height: 2
                color: "black"
                opacity: 0.5
            }

             // whitet space
            Rectangle{
                Layout.fillWidth: true
                height: 10
                opacity: 0
            }

            Text {
                Layout.fillWidth: true
                text: qsTr("Connecxion")
                font {
                    pixelSize: 25
                    family: "Texta"
                    styleName: "Black"
                }
            }

            MyIconTextButton{
                title: "Logout"
                source: "qrc:/mainLib/icons/logout.svg"
                
                mouseArea.onClicked:{
                    console.log("Logout")
                    fAuthManager.logout();
                    stackView.clear();
                    stackView.push("../LoginPage.qml");
                    hideSideMenu();
                }
            }

            MyTextButton{
                title: "Disable"
                color: "red"
                txSubTitle.visible: false
                
                mouseArea.onClicked:{
                    console.log("Disable Account")
                }
            }

            MyTextButton{
                title: "Delete"
                color: "red"
                txSubTitle.visible: false
                
                mouseArea.onClicked:{
                    console.log("Delete Account")
                }
            }

            Rectangle{
                Layout.fillWidth: true
                height: 10
                opacity: 0
            }
        }
    }

    // Dialog To Update User Data
    Dialog{
        id: dialog

        title: "Update " + root.feild
        standardButtons: Dialog.Ok | Dialog.Cancel
        visible: false
        anchors.centerIn: parent

        ColumnLayout{
            id: dialogLayout

            spacing: 10
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10

            TextField{
                id: dialogInput

                Layout.fillWidth: true
                height: 20
            }
        }

        onAccepted:{
            console.log("Sending message: " + dialogInput.text);
            
            if(root.feild === "username")
                fUserManager.updateUser(root.feild, dialogInput.text);

            if(root.feild === "email")
                fUserManager.updateUser(root.feild, dialogInput.text);

            if(root.feild === "tel")
                fUserManager.updateUser(root.feild, dialogInput.text);

            dialogInput.text = "";
        }

    }

    // Dialog To Update User Password
    Dialog{
        id: dialogPassword

        title: "Update " + root.feild
        standardButtons: Dialog.Ok | Dialog.Cancel
        visible: false
        anchors.centerIn: parent

        ColumnLayout{
            id: dialogPasswordLayout

            spacing: 10
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10

            Text{
                text: "Old Password"
            }
            TextField{
                id: dialogOldPasswordInput

                Layout.fillWidth: true
                height: 20
            }

            Text{
                text: "New Password"
            }
            TextField{
                id: dialogNewPasswordInput

                Layout.fillWidth: true
                height: 20
            }

            Text{
                text: "Validate Password"
            }
            TextField{
                id: dialogCheckNewPasswordInput

                Layout.fillWidth: true
                height: 20
            }
        }

        onAccepted:{            
            if(root.feild === "password")
            {
                console.log("Old password: ", dialogOldPasswordInput.text);
                fUserManager.updateUser(root.feild, dialogInput.text, dialogOldPasswordInput.text);
            }

            dialogOldPasswordInput.text = "";
            dialogNewPasswordInput.text = "";
            dialogCheckNewPasswordInput.text = "";
        }
    }
}
