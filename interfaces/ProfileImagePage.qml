import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5
import QtQuick.Effects 6.5

import mainLib 1.0

Item {
    id: root

    property bool isProfile: false

    Connections {
        target: fImageUploader
        
        function onImagePathChanged() {

            // DISPLAYING HEADERS
            myHeader.visible = true;
            myHeader.height = 50;
            // if(fetchProfilePage()){
               
            // }

            fUserManager.updateImagePath(fImageUploader.imagePath);

            // Update Profile Image
            sideMenu.initialize();

            // Switch Pages
            if(isProfile) {
				// Switch Pages
				stackView.pop("SettingsPage.qml");
				stackView.pop();
				stackView.push("SettingsPage.qml");
			} else {
				// Switch Pages
				stackView.clear();

				// Display The Header
				stackView.push("HomePage.qml");
			}

            console.log("Image Path Image Uploader" + fImageUploader.imagePath)
            
            console.log("Image Path User" + fUserManager.getuserData().imagePath)
            
        }
    }

    function fetchProfilePage(){
        var request = createRequest();

        // Set the request URL and method
        request.open("POST", url + "api/imageManager.php", true);
        request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        // Prepare the request data
        var requestData = "submit=&type=fetch&idProduct=&idUser=" + encodeURIComponent(main.userID);

        // Handle the response
        request.onreadystatechange = function () {
            if (request.readyState === XMLHttpRequest.DONE) {
                var serverResponse = JSON.parse(request.responseText); // Parse the JSON response
                if (request.status === 200) {

                    // Request successful
                    // console.log("Response received:", request.responseText);
                    var data = serverResponse.data;
                    main.profileImage = data[0].path;

                    updateProfileImage();

                    if (isProfile) {
                        // Switch Pages
                        console.log("Save Clicked");
                        stackView.pop("SettingsPage.qml");
                        stackView.pop();
                        stackView.push("SettingsPage.qml");
                    } else {
                        // Switch Pages
                        console.log("Save Clicked");
                        stackView.clear();

                        // Display The Header
                        stackView.push("HomePage.qml");
                    }
                    
                    return true;
                    
                } else {

                    // Request failed
                    console.log("Response received:", request.responseText);
                }
            }
        };

        // Send the request
        request.send(requestData);
    }

    function accepted(){
        imagePic.source = main.profileImageTemp;
    }

    Component.onCompleted: {
        if (myHeader.visible)
            isProfile = true;
        myHeader.visible = false;
        myHeader.height = 0;
    }

    FImageUploader {
        id: fImageUploader
    }

    ColumnLayout {
        id: columnInput

        width: parent.width
        anchors.centerIn: parent
        spacing: 20

        Text {
            id: textTitle

            Layout.columnSpan: 2
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true

            font {
                pixelSize: 25
                family: "Texta"
                styleName: "Bold"
            }

            color: "#646464"
            text: qsTr("Profile Image")
        }

        ColumnLayout {
            id: clBackground
            spacing: 10

            Rectangle {

                Layout.fillWidth: true
                Layout.margins: 10
                height: 200
                color: "#dcdcdc"
                radius: 10
                clip: true

                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowBlur: 0.6
                    shadowVerticalOffset: 5
                    shadowOpacity: 0.5
                }

                Image {
                    width: parent.width
                    source: "qrc:/mainLib/images/Bitmap.png"
                    anchors.horizontalCenter: parent.horizontalCenter
                    fillMode: Image.PreserveAspectFit

                    // Profile Image Mask
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        maskEnabled: true
                        maskSource: Image {
                            id: pic_Circle
                            width: clBackground.width
                            height: 200
                            source: "qrc:/mainLib/images/CardBackground.svg"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }
            }

            Rectangle {

                opacity: 0

                Layout.fillWidth: true
                height: 200
                color: "#dcdcdc"
                radius: 10
                clip: true

                Column {
                    anchors.centerIn: parent
                    spacing: 10
                }

                MouseArea {
                    anchors.fill: parent
                }
            }
        }

        Rectangle {
            id: rcProfileWrapper

            width: 150
            height: 150
            color: "#ffffff"
            radius: width / 2
            anchors.centerIn: clBackground

            // Profile Picture
            Image {
                id: imagePic

                source: fUserManager.getImageUrl()
                fillMode: Image.PreserveAspectFit
                width: parent.height - 10
                height: parent.width - 10
                anchors.centerIn: parent

                // Profile Image Mask
                layer.enabled: true
                layer.effect: MultiEffect {
                    maskEnabled: true
                    maskSource: Image {
                        id: picCircle
                        source: "qrc:/mainLib/images/Pic_Circle.png"
                        fillMode: Image.PreserveAspectFit
                    }
                }

                Rectangle {
                    width: parent.width
                    height: parent.height / 3
                    anchors.bottom: parent.bottom
                    color: "black"
                    opacity: 0.5

                    Image {
                        source: "qrc:/mainLib/icons/camera_add.svg"
                        fillMode: Image.PreserveAspectFit
                        width: 40
                        height: 30
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        id: maUpdateImage
                        anchors.fill: parent

                        onClicked: {
                            console.log("Profile Image Updated");
                            //MARK: FILE DIALOG OPEN
                            customDialogLoader.source = "components/MyCustomDialog.qml";
                            customDialogLoader.item.uploadProfileImageDialog.onAccepted.connect(accepted);
                            customDialogLoader.item.uploadProfileImageDialog.open();
                        }
                    }
                }
            }
        }
    }

    RowLayout {

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10

        Button {
            id: btnSave

            text: "Save"

            onClicked: {
                if (main.profileImage !== ""){
                    main.profileImage = main.profileImageTemp;
                    fImageUploader.uploadImage(main.profileImage, main.userID.toString());
                }else {
                    customDialogLoader.source = "components/MyCustomDialog.qml";
                    customDialogLoader.item.profileImageErrorMessageDialog.open();
                }
            }
        }

        Button {
            id: btnSkip

            text: isProfile ? "Cancel" : "Skip"

            onClicked: {
                // Display The Header
                myHeader.visible = true;
                myHeader.height = 50;
                if (isProfile) {
                    // Switch Pages
                    console.log("Skiped Clicked");
                    stackView.pop();
                } else {
                    // Switch Pages
                    console.log("Skiped Clicked");
                    stackView.clear();
                    stackView.push("HomePage.qml");
                }
            }
        }
    }
}
