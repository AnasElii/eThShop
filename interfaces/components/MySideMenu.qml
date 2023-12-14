import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5

Item{
    id: root

    function hideSideMenu(){
        sideMenu.anchors.left = parent.right;
        sideMenuBackground.visible = false;
    }

    function initialize(){        
        // MARK: - CHANGING USER NAME
        tfUserName.text = main.user.username;
        
        // MARk: - CHECK IF THE USER IS A SELLER
        if(main.user.role === true)
        {
            profileWrapper.source = fUserManager.getImageUrl();
            itbAccount.visible = true
            itbProductList.visible = true
            
            if(main.user.valid === true)
                profileWrapper.isValidate = true;
        }
    }

    function clearAtLogout(){
        itbAccount.visible = false
        itbProductList.visible = false
        profileWrapper.isValidate = false;
    }

    Rectangle{
        id: background
        
        width: rlLayout.width
        height: parent.height
        color: '#FFF'
    }

    RowLayout{
        id: rlLayout
        spacing: 5

        Rectangle{
            width: 10
            Layout.fillHeight: true
        }
        
        ColumnLayout
        {
            id: clContent
            
            spacing: 10

            // whitet space
            Rectangle{
                Layout.fillWidth: true
                height: 10
                opacity: 0
            }

            // Header
            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                spacing: 10

                // Profile Pic Wrapper
                MyProfileWrapper{
                    id: profileWrapper
                    source: main.user ? fUserManager.getImageUrl() : ""

                    isOnline: true
                    isValidate : false
                }

                // Title
                ColumnLayout {
                    spacing: 10
                    Layout.alignment: Qt.AlignCenter

                    Text {
                        id: tfUserName
                        text: ""
                        font {
                            pixelSize: 25
                            family: "Texta"
                            styleName: "Black"
                        }
                    }
                }
            }

            // whitet space
            Rectangle{
                Layout.fillWidth: true
                height: 10
                opacity: 0
            }

            // Seperator
            Rectangle {
                Layout.fillWidth: true
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                height: 2
                color: "black"
                opacity: 0.5
            }

            // Account
            MyIconTextButton{
                id: itbAccount

                Layout.leftMargin: 10
                Layout.rightMargin: 10
                title: "Account"
                source: "qrc:/mainLib/icons/account.svg"
                visible: false
                
                mouseArea.onClicked:{
                    
                    console.log("Display Account")
                    token = userID;
                    stackView.push("../UserPage.qml")
                    hideSideMenu();

                }
            }

            // My Products List
            MyIconTextButton{
                id: itbProductList

                Layout.leftMargin: 10
                Layout.rightMargin: 10
                title: "My products"
                source: "qrc:/mainLib/icons/list-ul-alt.svg"
                visible: false
                
                mouseArea.onClicked:{
                    console.log("My Products Page")
                    stackView.push("../MyProductPage.qml")
                    hideSideMenu();
                }
            }

            // Enregister
            MyIconTextButton{
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                title: "Favorite"
                source: "qrc:/mainLib/icons/save.svg"
                
                mouseArea.onClicked:{
                    console.log("Favorite Page")
                    stackView.push("../FavoritePage.qml")
                    hideSideMenu();
                }
            }

            // Settings
            MyIconTextButton{
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                title: "Settings"
                source: "qrc:/mainLib/icons/settings-minimalistic.svg"
                
                mouseArea.onClicked:{
                    console.log("Settings page")
                    stackView.push("../SettingsPage.qml")
                    hideSideMenu();

                }
            }

            // Settings
            MyIconTextButton{
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                title: "Logout"
                source: "qrc:/mainLib/icons/logout.svg"
                
                mouseArea.onClicked:{
                    main.logout();
                    clearAtLogout();
                    hideSideMenu();
                }
            }

            // whitet space
            Rectangle{
                Layout.fillWidth: true
                height: 10
                opacity: 0
            }

            // Seperator
            Rectangle {
                Layout.fillWidth: true
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                height: 2
                color: "black"
                opacity: 0.5
            }

            // Invite Friends
            MyIconTextButton{
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                title: "Invite Friend"
                source: "qrc:/mainLib/icons/user-plus.svg"
                
                mouseArea.onClicked:{
                    console.log("Privacy and Security Page")
                }
            }

            // What New
            MyIconTextButton{
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                title: "What New"
                source: "qrc:/mainLib/icons/info.svg"
                
                mouseArea.onClicked:{
                    console.log("Change Language")
                }
            }
        }

        Rectangle{
            width: 50
            Layout.fillHeight: true
        }
    }
}
