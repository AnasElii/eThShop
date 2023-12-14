import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5
import QtQuick.Effects 6.5
import "components"

Item {
    id: root

    property string searchText: ""

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
                    console.log("Response received:", request.responseText);
                    var products = JSON.parse(JSON.stringify(serverResponse.data));
                    var likedProducts = JSON.parse(JSON.stringify(serverResponse.likedList));
                    var favoriteProducts = JSON.parse(JSON.stringify(serverResponse.favoriteList));
                    var editeProducts = JSON.parse(JSON.stringify(serverResponse.userList));

                    // Clear existing items in the list model
                    productListModel.clear();

                    // Append new items to the list model
                    for (var i = 0; i < (products.length); i++) {
                        productListModel.append({
                                "prId": products[i].id,
                                "prTitle": products[i].name,
                                "prPrice": products[i].price,
                                "prPromo": products[i].sold,
                                "prLocation": products[i].location,
                                "prDateTime": products[i].dateAdd,
                                "prBestSeller": products[i].bestseller,
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
                        for (var j = 0; j < productListModel.count; j++) {
                            if (productListModel.get(j).prId === likedProducts[i].idProduct) {
                                // Update the item in the listModel
                                productListModel.setProperty(j, "prLike", true);
                                // You can update other properties here as needed
                                break; // Exit the inner loop since the item is found and updated
                            }
                        }
                    }

                    // Update favorite products
                    for (var i = 0; i < favoriteProducts.length; i++) {
                        // Find the corresponding item in the listModel
                        for (var j = 0; j < productListModel.count; j++) {
                            if (productListModel.get(j).prId === favoriteProducts[i].idProduct) {
                                // Update the item in the listModel
                                productListModel.setProperty(j, "prFavorite", true);
                                // You can update other properties here as needed
                                break; // Exit the inner loop since the item is found and updated
                            }
                        }
                    }

                    // Update favorite products
                    for (var i = 0; i < editeProducts.length; i++) {
                        // Find the corresponding item in the listModel
                        for (var j = 0; j < productListModel.count; j++) {
                            if (productListModel.get(j).prId === editeProducts[i].id) {
                                // Update the item in the listModel
                                productListModel.setProperty(j, "prEditable", true);
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
        myHeader.isHomePage = false;
        myHeader.text = "Search";
    }

    ListModel {
        id: productListModel
    }

    ListModel {
        id: searchListModel
    }

    ScrollView {
        id: svContent

        width: root.width
        height: root.height

        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff

        contentChildren: GridLayout {
            id: clContent

            width: root.width
            columns: 2
            columnSpacing: 10
            rowSpacing: 10

            //MARK: 1- SEARCH FIELD
            RowLayout {
                spacing: 5
                Layout.columnSpan: 2
                Layout.fillWidth: true
                Layout.margins: 10

                TextField {
                    id: tfSearch

                    Layout.fillWidth: true
                    placeholderText: qsTr("Search...")
                    font.pixelSize: 16
                    color: "black"

                    onTextChanged: {
                        //MARK: DISPLAY ORIGINAL LIST
                        if (tfSearch.text === "") {
                            console.log("Text is Empty:) ");

                            //MARK: CLEAR LISTS
                            productListModel.clear();
                            searchListModel.clear();

                            //MARK: CLEAR SEARCH TEXT
                            searchText = "";

                            //MARK: FETCH PRODUCTS FROM SERVER
                            fetchProducts();
                            return;
                        } else {
                            console.log("Text is not Empty :)");
                        }
                    }

                    onEditingFinished: {
                        searchText = tfSearch.text.toLowerCase();
                        var filteredList = [];
                        for (var i = 0; i < productListModel.count; i++) {
                            
                            var itemName = "";
                            var itemName = productListModel.get(i).prTitle.toLowerCase();

                            if (itemName.indexOf(searchText) !== -1) {
                                searchListModel.append(productListModel.get(i));
                            }
                        }
                    }
                }

                Button {
                    id: btnSearch

                    Layout.alignment: Qt.AlignRight
                    text: qsTr("Search")
                    flat: true

                    onClicked: {
                        //MARK: CLEAR SEARCH LIST
                        productListModel.clear();

                        //MARK: COPY THE CONTENTS OF SEARCH LIST TO THE SEARCH LISTS
                        for (var i = 0; i < searchListModel.count; i++) {
                            productListModel.append({
                                    "prId": searchListModel.get(i).prId,
                                    "prTitle": searchListModel.get(i).prTitle,
                                    "prPrice": searchListModel.get(i).prPrice,
                                    "prPromo": searchListModel.get(i).prPromo,
                                    "prLocation": searchListModel.get(i).prLocation,
                                    "prDateTime": searchListModel.get(i).prDateTime,
                                    "prBestSeller": searchListModel.get(i).prBestSeller,
                                    "prIsVisible": searchListModel.get(i).prIsVisible,
                                    "prSellerId": searchListModel.get(i).prSellerId,
                                    "path": searchListModel.get(i).path,
                                    "prLike": searchListModel.get(i).prLike,
                                    "prFavorite": searchListModel.get(i).prFavorite,
                                    "prEditable": searchListModel.get(i).prEditable
                                });
                        }

                        //MARK: CLEAR MODEL LIST
                        console.log("Clear Mode List From The Button");
                        searchListModel.clear();
                    }
                }
            }

            //MARK: 2- PRODUCT LISTS
            ColumnLayout {
                id: clProductList

                spacing: 10
                Layout.columnSpan: 2
                Layout.fillWidth: true
                Layout.margins: 10

                Rectangle {
                    Layout.fillWidth: true
                    height: 5
                    opacity: 0
                }

                Repeater {
                    id: repeater

                    model: productListModel
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
                    height: 5
                }
            }

        }
    }
}
