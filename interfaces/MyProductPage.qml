import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5
import "components"

Item{
    id: root

    // List model
    function fetchProducts(type) {
        var request = createRequest();

        // Set the request URL and method
        request.open("POST", configManager.getApisPath() + "fetchProducts.php", true);
        request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        // Prepare the request data
        var requestData = "submit=&type=" + encodeURIComponent(type) + "&idUser=" + encodeURIComponent(userID);

        // Handle the response
        request.onreadystatechange = function () {
            if (request.readyState === XMLHttpRequest.DONE) {
                var serverResponse = JSON.parse(request.responseText); // Parse the JSON response
                if (request.status === 200) {

                    // Request successful
                    // console.log("Response received:", request.responseText);
                    var products = JSON.parse(JSON.stringify(serverResponse.data));
                    var likedProducts = JSON.parse(JSON.stringify(serverResponse.likedList));
                    var favoriteProducts = JSON.parse(JSON.stringify(serverResponse.favoriteList));

                    // Clear existing items in the list model
                    userProductsList.clear();

                    // Append new items to the list model
                    for (var i = 0; i < (products.length); i++) {
                        userProductsList.append({
                            "prId": products[i].id,
                            "prTitle": products[i].name,
                            "prPrice": products[i].price,
                            "prPromo": products[i].sold,
                            "prLocation": products[i].location,
                            "prDateTime": products[i].dateAdd,
                            "prBestSeller": products[i].bestseller,
                            "prIsVisible" : products[i].visible,
                            "prSellerId": products[i].idUser,
                            "path": products[i].path,
                            "prLike": false,
                            "prFavorite" : false,
                            "prEditable" : true
                        });
                    }

                    // Update liked products
                    for (var i = 0; i < likedProducts.length; i++) {
                        
                        // Find the corresponding item in the listModel
                        for (var j = 0; j < userProductsList.count; j++) {
                            
                            console.log("Liked: " + likedProducts[i].id + " | user id: " + likedProducts[i].idUser + " | product id: " + likedProducts[i].idProduct);
                            if (userProductsList.get(j).prId === likedProducts[i].idProduct) {
                                // Update the item in the listModel
                                userProductsList.setProperty(j, "prLike", true);
                                // You can update other properties here as needed
                                break; // Exit the inner loop since the item is found and updated
                            }

                        }

                    }

                    // Update favorite products
                    for (var i = 0; i < favoriteProducts.length; i++) {
                        
                        // Find the corresponding item in the listModel
                        for (var j = 0; j < userProductsList.count; j++) {
                            
                            if (userProductsList.get(j).prId === favoriteProducts[i].idProduct) {
                                // Update the item in the listModel
                                userProductsList.setProperty(j, "prFavorite", true);
                                // You can update other properties here as needed
                                break; // Exit the inner loop since the item is found and updated
                            }

                        }

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

    // Initialize
    function initialize() {
        fetchProducts("userProducts");
    }
    
    // Calculate the price promo
    function calculateProduct(price, promo){
        return promo > 1 ? (price - (price * promo) / 100) : price
    }

    Component.onCompleted:{
        myHeader.isHomePage = false;
        myHeader.text = "My Products"
        initialize();
    }

    ListModel{
        id: userProductsList
    }

    RowLayout{
        id: rlButtons
            
        spacing: 10
        anchors.top : root.top
        anchors.topMargin: 10
        anchors.horizontalCenter : root.horizontalCenter

        Text {

            text: "My Products"
            font{
                pixelSize: 15
                family: "Texta"
                styleName: "Regular"
            }

            Rectangle{
                id: rcMyProduct

                width: parent.width+ 10
                height: 5
                anchors.top: parent.bottom
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
            
            }

            MouseArea{
            
                anchors.fill: parent
                onClicked:{
                    
                    if(rcMyProduct.visible == false)
                    {
                        
                        rcMyProduct.visible = true;
                        rcHidden.visible = false;
                        fetchProducts("userProducts");
                        console.log("My Product Clicked");

                    }

                }
            
            }

        }

        Text {

            text: "Hidden"
            font{
                pixelSize: 15
                family: "Texta"
                styleName: "Regular"
            }

            Rectangle{
                id: rcHidden

                width: parent.width+ 10
                height: 5
                anchors.top: parent.bottom
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
                visible: false
            
            }

            MouseArea{

                anchors.fill: parent
                onClicked:{

                    rcMyProduct.visible = false;
                    rcHidden.visible = true;
                    fetchProducts("userHiddenProducts");
                     console.log("Hidden Clicked");

                }
            
            }

        }
    }

    ScrollView{

        width: root.width
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: rlButtons.bottom
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 10

        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff

        ColumnLayout {
            id: clContent

            width: parent.width
            spacing: 10

            Rectangle{
                Layout.fillWidth: true
                height: 5;
                opacity: 0
            }

            Repeater {
                id: repeater

                model: userProductsList
                delegate: MyCard {

                    Layout.fillWidth: true

                    productId: model.prId
                    title: model.prTitle
                    price: calculateProduct(model.prPrice, model.prPromo)
                    promo: model.prPromo
                    location: model.prLocation
                    dateTime: model.prDateTime
                    categories: "Car, Sport"
                    display: model.prBestSeller
                    isVisible: model.prIsVisible
                    sellerId: model.prSellerId
                    imagePath: model.path
                    isEditable: model.prEditable
                    isFavorite : model.prFavorite;
                    isLiked : model.prLike;

                    maImage.onClicked: {
                        token = model.prId;
                        console.log("Product Id: " + token);
                        stackView.push("ProductPage.qml");
                    }

                    maInfo.onClicked: {
                        token = model.prId;
                        console.log("Product Id: " + token);
                        stackView.pop();
                        stackView.push("ProductPage.qml");
                    }
                }
            }
        }
    }
    
}
