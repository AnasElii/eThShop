import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5
import QtQuick.Effects 6.5
import QtQml 2.0

import mainLib 1.0


Item {
    id: root

    height: clContent.height

    property string productId
    property string title: "Surfing Sweatshirt, Surfing T-shirts..."
    property string imagePath: "images/Legion-5-AMD.jpg"
    property string hoverPath: configManager.getApisPath() + "/backend/images/x-name_03.png"
    property string price: "3,600"
    property string promo: "60"
    property string categories: "Clothes, Sport"
    property string location: "Tiflet"
    property string dateTime: "Week Ago"
    property string sellerId 
    property bool display: false
    property bool isFavorite : false
    property bool isEditable: false
    property bool isLiked : false
    property bool isVisible : true
    property alias maImage: maImage
    property alias maInfo: maInfo

    // Like Manager
    function likeManager(type) {
        var request = createRequest();

        // Set the request URL and method
        request.open("POST", url + "api/likeManager.php", true);
        request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        // Prepare the request data
        status = "Preparing request data...";
        var requestData = "submit=&type=" + encodeURIComponent(type) + "&idProduct=" + encodeURIComponent(productId) + "&idUser=" + encodeURIComponent(userID);

        // Handle the response
        status = "Handling response...";
        request.onreadystatechange = function () {
            if (request.readyState === XMLHttpRequest.DONE) {
                var serverResponse = JSON.parse(request.responseText); // Parse the JSON response
                if (request.status === 200) {

                    // Request successful
                    // console.log("Response received:", request.responseText);

                } else {

                    // Request failed
                    status = serverResponse.status;
                    response = serverResponse.message;
                }
            }
        };

        // Send the request
        request.send(requestData);
    }

    // Faborite Manager
    function favoriteManager(type) {
        var request = createRequest();

        // Set the request URL and method
        request.open("POST", url + "api/favoriteManager.php", true);
        request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        // Prepare the request data
        status = "Preparing request data...";
        var requestData = "submit=&type=" + encodeURIComponent(type) + "&idProduct=" + encodeURIComponent(productId) + "&idUser=" + encodeURIComponent(userID);

        // Handle the response
        status = "Handling response...";
        request.onreadystatechange = function () {
            if (request.readyState === XMLHttpRequest.DONE) {
                var serverResponse = JSON.parse(request.responseText); // Parse the JSON response
                if (request.status === 200) {

                    // Request successful
                    console.log("Response received:", request.responseText);

                } else {

                    // Request failed
                    status = serverResponse.status;
                    response = serverResponse.message;
                }
            }
        };

        // Send the request
        request.send(requestData);
    }

    // Product Manager
    function productManger(type) {
        var request = createRequest();

        // Set the request URL and method
        request.open("POST", url + "api/productManager.php", true);
        request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        // Prepare the request data
        if(type === "update")
            var requestData = "submit=&type=" + encodeURIComponent(type) + "&idProduct=" + encodeURIComponent(root.productId)
        else if (type === "hide")
            var requestData = "submit=&type=" + encodeURIComponent(type) + "&idProduct=" + encodeURIComponent(root.productId) + "&visible=" + encodeURIComponent(!isVisible == true ? 1 : 0);
        else if(type === "delete")
            var requestData = "submit=&type=" + encodeURIComponent(type) + "&idProduct=" + encodeURIComponent(root.productId) + "&idUser=" + encodeURIComponent(main.userID)

        // Handle the response
        request.onreadystatechange = function () {
            if (request.readyState === XMLHttpRequest.DONE) {

                // Parse the JSON response
                var serverResponse = JSON.parse(request.responseText);
                if (request.status === 200) {

                    // Request successful
                    console.log("Response received:", request.responseText);

                    if(type === "update")
                    {
                        main.updateProductInfo = serverResponse.productInfo;
                        main.imageSource = serverResponse.productImages;
                        isEditable = true;
                    }

                } else {

                    // Request failed
                    console.log("Response received:", request.responseText);

                }

            }
        };

        // Send the request
        request.send(requestData);
    }

    // Fetch Data
    function fetchProductInfo(){
        var request = createRequest();

        // Set the request URL and method
        request.open("POST", url + "api/fetchProducts.php", true);
        request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        // Prepare the request data
        var requestData = "submit=&type=productForUpdate&idUser=" + encodeURIComponent(main.userID) + "&idProduct=" + encodeURIComponent(root.productId)

        // Handle the response
        request.onreadystatechange = function () {
            if (request.readyState === XMLHttpRequest.DONE) {

                // Parse the JSON response
                var serverResponse = JSON.parse(request.responseText);
                if (request.status === 200) {

                    // Request successful
                    console.log("Response received:", request.responseText);

                    // fill tables with product data
                    main.updateProductInfo = serverResponse.data[0];
                    // main.imageSource = serverResponse.data[0].images;
                    main.isEditable = true;

                    // Open Update Product
                    stackView.push("../AddProductPage.qml");

                } else {

                    // Request failed
                    console.log("Status: " + status + " Message: " + response);
                }

            }
        };

        // Send the request
        request.send(requestData);
    }

    // CRUD
        // Delete
    function deleteProduct() {
        productManger("delete");
        console.log("Product Deleted! From the card");
        root.visible = false;
    }

    onWidthChanged:{
        imgProduct.width = parent.width
    }

    FTimeManager{
        id: timeManager
    }

    ColumnLayout{
        id: clContent

        width: root.width
        spacing: 0

        // Product Image
        Rectangle{
            id: rcProductImage
            Layout.fillWidth: true
            height: 200
            color: "#FFF"
            clip: true

            Image{
                id: imgProduct

                fillMode: Image.PreserveAspectFit
                source: url + root.imagePath
                anchors.horizontalCenter: parent.horizontalCenter
                width : parent.width

                MouseArea{
                    id: maImage

                    anchors.fill: parent
                }
            }

            MyIconButton {
                id: myIconButton

                visible: false
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 10

            }

            RowLayout{
                id: rlTopButtons
                z: 2

                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 10

                MyIconButton {
                    id: mibShere

                    z: 2
                    source: "qrc:/mainLib/icons/share_2.svg"
                    
                    maIconButton.onClicked:{
                        console.log("Share Clicked")
                    }
                }

                MyIconButton {
                    id: mibComment

                    visible: false
                    source: "qrc:/mainLib/icons/comment.svg"

                    maIconButton.onClicked:{
                        console.log("Comment Clicked")
                    }
                }

                MyIconButton {
                    id: mibLike

                    source: root.isLiked === true ? "qrc:/mainLib/icons/dislike.svg" : "qrc:/mainLib/icons/like.svg" 

                    maIconButton.onClicked:{
                        if(!root.isLiked){

                            likeManager("add");
                            root.isLiked = true;

                        }else {

                            likeManager("delete");
                            root.isLiked = false;
                        }

                    }
                }

            }

            MyIconButton {
                id: mibEdit

                anchors.top: parent.top
                anchors.left: parent.left
                width: 30
                height: 30
                anchors.margins: 10
                visible: root.isEditable === true ? true : false;
                source: "qrc:/mainLib/icons/dots_vertical.svg"

                maIconButton.onClicked:{
                    console.log("edit Clicked")
                    rcEditMenu.visible === false ? rcEditMenu.visible = true : rcEditMenu.visible = false;
                }
            }


            // Favorite
            MyIconButton {
                id: ibFavorite

                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.margins: 10
                source: root.isFavorite === true ? "qrc:/mainLib/icons/bookmark_no.svg" : "qrc:/mainLib/icons/bookmark.svg"

                maIconButton.onClicked:{
                    if(!root.isFavorite){
                        favoriteManager("add");
                        root.isFavorite = true;
                    }else {
                        favoriteManager("delete");
                        root.isFavorite = false;
                        if(!myHeader.isHomePage){
                            root.visible = false;u
                        }
                    }   
                    console.log("Save Clicked")
                }
            }

        }

        // Product Info
        Rectangle{
            Layout.fillWidth: true
            height:120
            color: "#F1F1F1"

            GridLayout{
                id:glProductInfo

                width: parent.width - 20
                anchors.horizontalCenter: parent.horizontalCenter
                columns: 2
                columnSpacing: 5
                rowSpacing: 10

                Text{
                    id: txTitle

                    Layout.columnSpan: 2
                    Layout.alignment: Qt.AlignLeft
                    text: root.title
                    font{
                        pixelSize: 25
                        family: "Texta"
                        styleName: "Bold"
                    }
                }

                RowLayout{
                    id: rlPrice

                    Layout.alignment: Qt.AlignLeft

                    Text{
                        id: txPrice

                        Layout.alignment: Qt.AlignHCenter
                        text: root.price
                        font{
                            pixelSize: 35
                            family: "Texta"
                            styleName: "Black"
                        }
                        color: "#A45D00"
                    }

                    Text{
                        id: txPromo

                        Layout.alignment: Qt.AlignHCenter
                        visible: root.promo > 1 ? true : false
                        text: "(" + root.promo + "%)"
                        font {
                            pixelSize: 15
                            family: "Texta"
                            styleName: "Italic"
                        }
                    }
                }

                MyIconText {
                    id: mitTime

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignRight
                    text: timeManager.getTimeAgo(root.dateTime)
                    source: "qrc:/mainLib/icons/date.svg"
                }

                Text{
                    id: txTag

                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    text: root.categories
                    color: "#646464"
                    font{
                        pixelSize: 15
                        family: "Texta"
                        styleName: "Regular"
                    }
                }

                MyIconText {
                    id: mitLocation

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignRight
                    text: root.location
                    source: "qrc:/mainLib/icons/location.svg"
                }

            }

            MouseArea{
                id: maInfo

                anchors.fill: parent
            }
        }


        layer.enabled: true
        layer.effect: MultiEffect{
            maskEnabled: true
            maskSource: Image{
                id: imgMask

                source: "qrc:/mainLib/images/CardBackground.svg"
            }
        }
    }

    Rectangle{
        id: rcEditMenu

        radius: 10
        width: 100
        height: clEditContent.height
        color: "#F1F1F1"
        visible : false
        
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 40
        anchors.leftMargin: 15

        ColumnLayout{
            id: clEditContent
            
            width: rcEditMenu.width

            Button{
                id: btnUpdate

                Layout.fillWidth: true
                text: "Update"
                flat: true

                onClicked:{
                    rcEditMenu.visible = false;
                    fetchProductInfo();
                } 
            }

            Button{
                id: btnHide

                Layout.fillWidth: true
                text: isVisible === true ? "Hide" : "Show"
                flat: true
                
                onClicked: {

                    productManger("hide");
                    root.visible = false;
                    console.log("Product Hide!");
                }
            }

            Button{
                id: btnDelete

                Layout.fillWidth: true
                text: "Delete"
                flat: true
                
                onClicked: {
                    

                    //MARK: DISPLAY VERIFICATION MESSAGE ON DELETE
                    customDialogLoader.source = "components/MyCustomDialog.qml"
                    customDialogLoader.item.deleteMessageDialog.text = "The Product " + root.title + " Will Be Deleted";
                    customDialogLoader.item.deleteMessageDialog.informativeText= "Do you want to save your changes?";
                    customDialogLoader.item.deleteMessageDialog.onOkClicked.connect(deleteProduct);
                    customDialogLoader.item.deleteMessageDialog.open()


                }
            }
        }
        
        layer.enabled: true
        layer.effect: MultiEffect{
            
            shadowEnabled : true
            shadowBlur : 0.6
            shadowOpacity : 0.2
            shadowColor : "black"

        }
    }
}
