import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5
import QtQuick.Effects 6.5
import QtQuick.Controls 6.5
import mainLib 1.0
import "components"

Item {
    id: root

    // SEARCH STRING
    property string searchText: ""

    // SELLER INFO
    property int sellerID
    property string username: ""
    property string email: ""
    property string tel: ""
    property int productsNumber: 0
    property int followersNumber: 0
    property var profileImage: [""]
    property bool isFollowed: false
    property bool isSeller: false
    property bool isOnline: false
    property bool isValidate: false
    property bool isEditable: false

    Connections {
        target: fSellerManager

        function onUserChanged() {
            // Debuging
            console.log("qml: User Data");

            // Getting user data
            var seller = fSellerManager.userData();

            // Filling User Data
            root.sellerID = seller.id;
            root.username = seller.username;
            root.email = seller.email;
            root.tel = seller.tel;
            root.profileImage = seller.imagePath;

            // Fill Wrap Image
            profileWrapper.source = fUserManager.getImageUrl()
            root.isSeller = seller.role;
            root.isValidate = seller.valid;
            root.isOnline = true;
            followManager("isFollowed");
            followManager("followersNumer");
            fetchProducts("userProducts");
            fetchProducts("userProductsCount");
        }

        function onProductCountChanged() {
            root.productsNumber = fSellerManager.productCount;
        }
    }

    // List model
    function fetchProducts(type) {
        var request = createRequest();

        // Set the request URL and method
        request.open("POST", url + "api/fetchProducts.php", true);
        request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        // Prepare the request data
        var requestData = "submit=&type=" + encodeURIComponent(type) + "&idUser=" + encodeURIComponent(root.sellerID);

        // Handle the response
        request.onreadystatechange = function () {
            if (request.readyState === XMLHttpRequest.DONE) {
                var serverResponse = JSON.parse(request.responseText); // Parse the JSON response
                if (request.status === 200) {

                    // Request successful
                    // console.log("Response received:", request.responseText);
                    if (type === "userProducts") {
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
                                    "prIsVisible": products[i].visible,
                                    "prSellerId": products[i].idUser,
                                    "path": products[i].path,
                                    "prLike": false,
                                    "prFavorite": false,
                                    "prEditable": isEditable
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
                    }
                    if (type === "userProductsCount") {
                        var data = JSON.parse(JSON.stringify(serverResponse.data));
                        root.productsNumber = parseInt(data[0].count);
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

    // Calculate the price promo
    function calculateProduct(price, promo) {
        return promo > 1 ? (price - (price * promo) / 100) : price;
    }

    // Follower Manager
    function followManager(type) {
        var request = createRequest();

        // Set the request URL and method
        request.open("POST", url + "api/followManager.php", true);
        request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        // Prepare the request data
        status = "Preparing request data...";
        console.log("seller ID: " + root.sellerID + " user ID: " + main.userID);
        var requestData = "submit=&type=" + encodeURIComponent(type) + "&idSeller=" + encodeURIComponent(root.sellerID) + "&idUser=" + encodeURIComponent(main.userID);

        // Handle the response
        request.onreadystatechange = function () {
            if (request.readyState === XMLHttpRequest.DONE) {
                var serverResponse = JSON.parse(request.responseText); // Parse the JSON response
                if (request.status === 200) {

                    // Request successful
                    console.log("Response received:", request.responseText);
                    if (type === "isFollowed") {
                        console.log("isFollowed " + serverResponse.idFollowed);
                        root.isFollowed = serverResponse.idFollowed;
                    }

                    if(type === "followersNumer"){
                        var data = JSON.parse(JSON.stringify(serverResponse.data));
                        console.log("followersNumer " + data[0].count);
                        root.followersNumber = parseInt(data[0].count);
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
        if (main.token == main.userID) {

            // Filling User Data
            root.sellerID = main.userID;
            root.username = main.user.username;
            root.email = main.user.email;
            root.tel = main.user.tel;
            root.isSeller = false;
            root.isValidate = main.user.valid;
            root.isOnline = true;
            root.productsNumber = fUserManager.productCount;
            root.profileImage = main.profileImage;
            root.isEditable = true;
            fetchProducts("userProducts");
            rlButtons.visible = true;
            myHeader.text = "User Page";
            fetchProducts("userProductsCount");
            followManager("followersNumer");

        } else {

            fSellerManager.getUser(parseInt(main.token));
            myHeader.text = "Seller Page";
            
        }

    }

    Component.onCompleted: {

        //MARK: INITIALIZATION
        initialize();

        //MARK: HEADER
        myHeader.visible = true;
        myHeader.height = 0;
        myHeader.isHomePage = false;
    }

    FUserManager {
        id: fSellerManager
    }

    ListModel {
        id: userProductsList
    }

    ListModel {
        id: searchListModel
    }

    ScrollView {
        id: scrollView

        width: root.width
        height: root.height

        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff

        contentChildren: ColumnLayout {
            id: clContent

            width: root.width
            implicitHeight: rcSpace.height

            Rectangle {
                id: rcSpace

                opacity: 0
                Layout.columnSpan: 2
                Layout.fillWidth: true
                Layout.margins: 10
                height: 200
            }

            Rectangle {
                id: rcBackground

                Layout.fillWidth: true
                Layout.margins: 10

                color: "#FFFFFF" // For example, set the color of the background
                radius: 10
                implicitHeight: clUserData.height // Make the background wrap the glContent's height

                ColumnLayout {
                    id: clUserData

                    width: parent.width

                    GridLayout {
                        id: glContent

                        Layout.fillWidth: true
                        Layout.margins: 10
                        columns: 2
                        rowSpacing: 10
                        columnSpacing: 5

                        // Profile Pic Wrapper
                        MyProfileWrapper {
                            id: profileWrapper

                            isOnline: root.isOnline
                            isValidate: root.isValidate
                            source: fUserManager.getImageUrl()
                        }

                        // User name & Follow button
                        ColumnLayout {
                            spacing: 10
                            Layout.margins: 5
                            clip: true

                            Text {
                                id: tfUserName

                                Layout.fillWidth: true
                                text: root.username
                                font {
                                    pixelSize: 25
                                    family: "Texta"
                                    styleName: "Black"
                                }
                            }

                            Button {
                                id: btnFollow

                                Layout.fillWidth: true
                                visible: root.isSeller == true ? true : false
                                height: 40
                                text: root.isFollowed == true ? qsTr("Followed") : qsTr("Follow")
                                font {
                                    pixelSize: 14
                                    family: "Texta Alt"
                                    styleName: "Regular"
                                }

                                onClicked: {
                                    if (root.isFollowed == true) {
                                        followManager("delete");
                                        btnFollow.text = "Follow";
                                        root.isFollowed = false;
                                    } else {
                                        followManager("add");
                                        btnFollow.text = "Followed";
                                        root.isFollowed = true;
                                    }
                                }
                            }
                        }

                        // Profile Statics
                        RowLayout {
                            id: rlStatics

                            spacing: 10
                            Layout.columnSpan: 2
                            Layout.alignment: Qt.AlignHCenter

                            Rectangle {
                                height: 50
                                width: 2
                                color: "black"
                                opacity: 0.2
                            }

                            // Number of products the user listed
                            ColumnLayout {
                                id: clProductNumber

                                Text {
                                    text: root.productsNumber
                                    Layout.alignment: Qt.AlignHCenter
                                    font {
                                        pixelSize: 20
                                        family: "Texta"
                                        styleName: "Heavy"
                                    }
                                }

                                Text {
                                    text: "Product"
                                    font {
                                        pixelSize: 20
                                        family: "Texta"
                                        styleName: "Regular"
                                    }
                                }
                            }

                            Rectangle {
                                height: 50
                                width: 2
                                color: "black"
                                opacity: 0.2
                            }

                            // Number of followers
                            ColumnLayout {
                                id: clFollowersNumber

                                Text {
                                    text: root.followersNumber
                                    Layout.alignment: Qt.AlignHCenter
                                    font {
                                        pixelSize: 20
                                        family: "Texta"
                                        styleName: "Heavy"
                                    }
                                }

                                Text {
                                    text: "Follower"
                                    font {
                                        pixelSize: 20
                                        family: "Texta"
                                        styleName: "Regular"
                                    }
                                }
                            }

                            Rectangle {
                                height: 50
                                width: 2
                                color: "black"
                                opacity: 0.2
                            }
                        }

                        // Style of listing Products
                        RowLayout {
                            id: rlStyle

                            spacing: 5
                            Layout.columnSpan: 2
                            Layout.alignment: Qt.AlignRight
                            Layout.rightMargin: 5

                            // Widget Style By Default
                            Rectangle {
                                id: imgBoxtStyle

                                width: 30
                                height: 25
                                color: "transparent"

                                Image {
                                    anchors.fill: parent
                                    source: "qrc:/mainLib/icons/widget.svg"
                                    fillMode: Image.PreserveAspectFit
                                }
                            }

                            // List Style
                            Rectangle {
                                id: imgListStyle

                                width: 25
                                height: 25
                                color: "transparent"

                                Image {
                                    anchors.fill: parent
                                    source: "qrc:/mainLib/icons/list-ul-alt.svg"
                                    fillMode: Image.PreserveAspectFit
                                    opacity: 0.8
                                }
                            }
                        }

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
                                        userProductsList.clear();
                                        searchListModel.clear();

                                        //MARK: CLEAR SEARCH TEXT
                                        searchText = "";

                                        //MARK: FETCH PRODUCTS FROM SERVER
                                        fetchProducts("userProducts");
                                        return;
                                    } else {
                                        console.log("Text is not Empty :)");
                                    }
                                }

                                onEditingFinished: {
                                    searchText = tfSearch.text.toLowerCase();
                                    var filteredList = [];
                                    for (var i = 0; i < userProductsList.count; i++) {
                                        var itemName = "";
                                        var itemName = userProductsList.get(i).prTitle.toLowerCase();
                                        if (itemName.indexOf(searchText) !== -1) {
                                            searchListModel.append(userProductsList.get(i));
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
                                    userProductsList.clear();

                                    //MARK: COPY THE CONTENTS OF SEARCH LIST TO THE SEARCH LISTS
                                    for (var i = 0; i < searchListModel.count; i++) {
                                        userProductsList.append({
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

                        // Products and Hidden Products List
                        RowLayout {
                            id: rlButtons

                            spacing: 10
                            Layout.columnSpan: 2
                            Layout.alignment: Qt.AlignHCenter
                            visible: false

                            Text {

                                text: "My Products"
                                font {
                                    pixelSize: 15
                                    family: "Texta"
                                    styleName: "Regular"
                                }

                                Rectangle {
                                    id: rcMyProduct

                                    width: parent.width + 10
                                    height: 5
                                    anchors.top: parent.bottom
                                    anchors.topMargin: 10
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                MouseArea {

                                    anchors.fill: parent
                                    onClicked: {
                                        if (rcMyProduct.visible == false) {
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
                                font {
                                    pixelSize: 15
                                    family: "Texta"
                                    styleName: "Regular"
                                }

                                Rectangle {
                                    id: rcHidden

                                    width: parent.width + 10
                                    height: 5
                                    anchors.top: parent.bottom
                                    anchors.topMargin: 10
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    visible: false
                                }

                                MouseArea {

                                    anchors.fill: parent
                                    onClicked: {
                                        if (rcHidden.visible == false && root.sellerID === main.userID) {
                                            rcMyProduct.visible = false;
                                            rcHidden.visible = true;
                                            fetchProducts("userHiddenProducts");
                                            console.log("Hidden Clicked");
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Product Lists
                    ColumnLayout {
                        id: clCards

                        Layout.fillWidth: true
                        Layout.margins: 10
                        spacing: 10

                        Rectangle {
                            Layout.fillWidth: true
                            height: 5
                            opacity: 0
                        }

                        // Card Repeater
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
                                isFavorite: model.prFavorite
                                isLiked: model.prLike

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
        }
    }

    Image {
        id: backgroundImage
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        source: "qrc:/mainLib/images/Bitmap.png"
        fillMode: Image.PreserveAspectFit
        z: -2
    }
}
