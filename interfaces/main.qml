import QtQuick 6.5
import Qt.labs.platform
import QtQuick.Controls 6.5
import QtWebSockets 1

import mainLib 1.0
import "components"

ApplicationWindow {
    id: main

    width: 320
    height: 650
    title: qsTr("Tif Store")
    visible: true

    property alias stackView: stackView

    property string response: ""
    property string status: ""
    property string source: ""
    property var user
    property int userID : 0
    property string token: ""
    property string url: configManager.getBasePathIPv4() + "/";
    property string urlTemp: configManager.getBasePathIPv4();
    property string profileImage
    property string profileImageTemp
    property var imageSource : []
    property var productInfo : []
    property var updateProductInfo : []
    property bool isEditable : false

    // Temp
    property string deleteTitle : ""
    property bool deleteType : false

    Connections{
        target: fAuthManager

        function onStatusChanged(){
            console.log("Login Status: ", fAuthManager.status);
        }
    }

    function createRequest() {
        // Create a new XMLHttpRequest object
        status = "Creating request...";
        var request = new XMLHttpRequest();
        return request;
    }

     // MARK: - LOGOUT
    function logout(){
        console.log("Logout")

        // Delete all pages and initialize Login
        stackView.clear();
        stackView.push("LoginPage.qml");
        
        // Clear user data
        fAuthManager.logout();
        main.user = null;
    }

    function updateProfileImage(){
        sideMenu.initialize();
    }

    Component.onCompleted: {
        // if(fAuthManager.isOnline()){
        //     stackView.push("Homepage.qml")
        // }
        // else
        // stackView.push("LoginPage.qml")
    }

    WebSocket {
        id: socket
    }

    FCategoryManager{
        id: fCategoryManager
    }

    FAuthManager {
        id: fAuthManager
    }

    FUserManager{
        id: fUserManager
    }

    StackView {
        id: stackView

        width: parent.width
        height: parent.height
        initialItem: HomePage{}
        
        // anchors{
        //     left: parent.left
        //     right: parent.right
        //     top: myHeader.bottom
        //     bottom: parent.bottom
        // }
    }


    // MyHeader{
    //     id: myHeader

    //     width: parent.width
        
    //     maLeft.onClicked:{
    //         if(myHeader.isHomePage === true){
    //             sideMenu.anchors.left = parent.left;
    //             sideMenuBackground.visible = true;
    //         }else{
    //             myHeader.isHomePage = true;
    //             myHeader.height = 50;
    //             stackView.push("HomePage.qml");
    //         }
    //     }
        
    //     maNotificationRight.onClicked:{

    //         isNotification = false;
            
    //     }

    //     maSearchRight.onClicked:{

    //         stackView.push("SearchPage.qml")
            
    //     }
    // }
    


    // Rectangle{
    //     id: sideMenuBackground

    //     anchors.fill: parent
    //     color: "black"
    //     opacity: 0.5
    //     visible: false

    //     MouseArea{
    //         anchors.fill: parent
    //         onClicked:{
    //             sideMenu.anchors.left = parent.right;
    //             parent.visible = false;
    //         }
    //     }
    // }


	// MySideMenu{
	// 	id: sideMenu

	// 	width: parent.width
	// 	height: parent.height
	// 	anchors.right: parent.left
	// 	z: 2
	// }


    // Dialog To Valid Product Deleted
    MessageDialog {
        id: messageDialog
        text: ""
        informativeText: "Do you want to save your changes?"
        buttons: MessageDialog.Ok | MessageDialog.Cancel
    }

    // MARK: - FILE DIALOG 
    FileDialog {
        id: fileDialog
        fileMode: FileDialog.OpenFiles
        folder: StandardPaths.writableLocation(StandardPaths.PicturesLocation)

        onAccepted: {
            // Handle the accepted files here
            main.imageSource = fileDialog.files
        }
    }

    Loader {
        id: customDialogLoader

        anchors.fill: parent
    }
}
