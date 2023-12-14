import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5
import "components"

Page {
    id: homePage

    title: qsTr("Home Page")

    // List model
    function fetchProducts() {
        var request = createRequest();

        // Set the request URL and method
        request.open("POST", url + "api/fetchProducts.php", true);
        request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        // Prepare the request data
        var requestData = "submit=&type=all&idUser=" + encodeURIComponent(userID);

        // Handle the response
        request.onreadystatechange = function () {
            if (request.readyState === XMLHttpRequest.DONE) {
                var serverResponse = JSON.parse(request.responseText); // Parse the JSON response
                if (request.status === 200) {

                    // Request successful
                    // console.log("Home Page: Response received:", request.responseText);
                    var products = JSON.parse(JSON.stringify(serverResponse.data));
                    var likedProducts = JSON.parse(JSON.stringify(serverResponse.likedList));
                    var favoriteProducts = JSON.parse(JSON.stringify(serverResponse.favoriteList));
                    var editeProducts = JSON.parse(JSON.stringify(serverResponse.userList));

                    // Clear existing items in the list model
                    listModel.clear();

                    // Append new items to the list model
                    for (var i = 0; i < (products.length); i++) {
                        listModel.append({
                                "prId": products[i].id,
                                "prTitle": products[i].name,
                                "prPrice": products[i].price,
                                "prPromo": products[i].sold,
                                "prLocation": products[i].location,
                                "prDateTime": products[i].dateAdd,
                                "prBestSeller": products[i].bestseller,
                                "prCategory": products[i].category,
                                "prIsVisible": products[i].visible,
                                "prSellerId": products[i].idUser,
                                "path": products[i].path,
                                "prLike": false,
                                "prFavorite": false,
                                "prEditable": false
                            });
                    }

                    // Update liked products
                    for (var i = 0; i < likedProducts.length; i++) {
                        // Find the corresponding item in the listModel
                        for (var j = 0; j < listModel.count; j++) {
                            if (listModel.get(j).prId === likedProducts[i].idProduct) {
                                // Update the item in the listModel
                                listModel.setProperty(j, "prLike", true);
                                // You can update other properties here as needed
                                break; // Exit the inner loop since the item is found and updated
                            }
                        }
                    }

                    // Update favorite products
                    for (var i = 0; i < favoriteProducts.length; i++) {
                        // Find the corresponding item in the listModel
                        for (var j = 0; j < listModel.count; j++) {
                            if (listModel.get(j).prId === favoriteProducts[i].idProduct) {
                                // Update the item in the listModel
                                listModel.setProperty(j, "prFavorite", true);
                                // You can update other properties here as needed
                                break; // Exit the inner loop since the item is found and updated
                            }
                        }
                    }

                    // Update favorite products
                    for (var i = 0; i < editeProducts.length; i++) {
                        // Find the corresponding item in the listModel
                        for (var j = 0; j < listModel.count; j++) {
                            if (listModel.get(j).prId === editeProducts[i].id) {
                                // Update the item in the listModel
                                listModel.setProperty(j, "prEditable", true);
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
        fetchProducts();
    }

    // Calculate the price promo
    function calculateProduct(price, promo) {
        return promo > 1 ? (price - (price * promo) / 100) : price;
    }

    Component.onCompleted: {
        initialize();
        // myHeader.isHomePage = true;
        // myHeader.isNotification = true;
        // myHeader.text = "Tiflet Store";
    }

    ListModel {
        id: listModel
    }


    header: MyNavBar{
        flickable: fkProducts
    }
    

    // Rectangle {
    //     id: rcAddProduct

    //     width: 60
    //     height: 60
    //     z: 1
    //     visible: main.user === null ? false : main.user.role

    //     radius: parent.width / 2
    //     color: "#FFD688"
    //     border.width: 2
    //     border.color: "#A45D00"
    //     opacity: .95

    //     anchors {
    //         bottom: parent.bottom
    //         right: parent.right
    //         margins: 20
    //     }

    //     Image {
    //         id: imgIcon

    //         anchors.fill: parent
    //         anchors.margins: 10
    //         source: "qrc:/mainLib/icons/write.svg"
    //         fillMode: Image.PreserveAspectFit
    //     }

    //     MouseArea {
    //         id: infoMouseArea
    //         anchors.fill: parent

    //         onClicked: {
    //             stackView.push("AddProductPage.qml");
    //         }
    //     }
    // }

    Flickable {
        id: fkProducts

        width: parent.width
        height: parent.height
        contentHeight: clContent.height

        ScrollIndicator.horizontal: ScrollIndicator { }

        ColumnLayout {
            id: clContent

            width: parent.width
            spacing: 10

            Rectangle {
                Layout.fillWidth: true
                height: 5
                opacity: 0
            }

            Repeater {
                id: repeater

                model: listModel
                delegate: MyCard {

                    Layout.fillWidth: true

                    productId: model.prId
                    title: model.prTitle
                    price: calculateProduct(model.prPrice, model.prPromo)
                    promo: model.prPromo
                    location: model.prLocation
                    dateTime: model.prDateTime
                    categories: model.prCategory
                    display: model.prBestSeller
                    isVisible: model.prIsVisible
                    sellerId: model.prSellerId
                    imagePath:  model.path
                    isEditable: model.prEditable
                    isFavorite: model.prFavorite
                    isLiked: model.prLike

                    maImage.onClicked: {
                        token = model.prId;
                        stackView.push("ProductPage.qml");
                    }

                    maInfo.onClicked: {
                        token = model.prId;
                        stackView.pop();
                        stackView.push("ProductPage.qml");
                    }
                }
            }

            Rectangle {
                opacity: 0
                Layout.fillWidth: true
                height: 2
            }
        }
    }

    footer: MyTabBar{}

}
