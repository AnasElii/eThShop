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
        target: fAuthManager
        function onStatusChanged(){
            var status = "role : success";
            if(fAuthManager.status === status){ 
                // Set Role
                // Debug
                console.log("Old Role: " + fUserManager.userData().role);
                fUserManager.userData().role = true;
                main.user = fUserManager.userData();
                // Debug
                console.log("New Role: " + fUserManager.userData().role);
                
                // Switch Pages
                // stackView.pop();
                stackView.push("ProfileImagePage.qml")

                // Display The Header
                // myHeader.visible = true;
                // myHeader.height= 50;

                // Initialize the side menu
                sideMenu.initialize();
            }
            else{

                console.log("Error | Status: ", fAuthManager.status)
            }
        }
    }

    Component.onCompleted:{

        myHeader.visible = false;
        myHeader.height= 0;
        
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
            text: qsTr("Type")
        }

        // Buyer button
        Rectangle {
            
            Layout.fillWidth: true
            height: 200
            color: "#dcdcdc"
            radius: 10
            clip: true

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowBlur: .6
                shadowVerticalOffset: 5
                shadowOpacity: .5
            }

            Column{
                anchors.centerIn: parent
                spacing: 10
                
                Image{
                    width: 60
                    height: 60
                    source: "qrc:/mainLib/icons/buy_cnvrt.svg"
                    anchors.horizontalCenter: parent.horizontalCenter
                    fillMode: Image.PreserveAspectFit
                }
                
                Text{
                    text: qsTr("Buyer")
                    font {
                        pixelSize: 50
                        family: "Texta Alt"
                        styleName: "Bold"
                    }
                }
            }

            MouseArea{
                id: buyerMouseArea

                anchors.fill: parent
                onClicked:{
                    // Switch Pages
                    stackView.clear();
                    stackView.push("HomePage.qml");

                    // Display The Header
                    myHeader.visible = true;
                    myHeader.height= 50;
                }
            }
        }

        // Seller Button
        Rectangle {
            
            Layout.fillWidth: true
            height: 200
            color: "#dcdcdc"
            radius: 10

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowBlur: .6
                shadowVerticalOffset: 5
                shadowOpacity: .5
            }

            Column{
                anchors.centerIn: parent
                spacing: 10
                
                Image{
                    width: 60
                    height: 60
                    source: "qrc:/mainLib/icons/shop.svg"
                    anchors.horizontalCenter: parent.horizontalCenter
                    fillMode: Image.PreserveAspectFit
                }
                
                Text{
                    text: qsTr("Seller")
                    font {
                        pixelSize: 50
                        family: "Texta Alt"
                        styleName: "Bold"
                    }
                }
            }  

            MouseArea{
                id: sellerMouseArea

                anchors.fill: parent
                onClicked:{
                    fAuthManager.setRole();
                }
            } 
        }
    }  
}
