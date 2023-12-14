import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5
import "components"

Item {
    id: root

    property string productID
    property string imagePath
    property string title
    property string price
    property string promo
    property string city
    property string dateTime
    property string descreption
    property string categories
    property string state
    property string sellerID
    property string sellerName
    property string sellerPhoneNumber
    property string sellerProfileImage
    property bool isOnline: false
    property bool isValidate: false
    property bool isFollowed: false
    property bool isLiked: false
    property bool isBestSeller: false
    property bool isMe: false

    // List model
    function fetchProducts() {
        var request = createRequest();

        // Set the request URL and method
        request.open("POST", configManager.getApisPath() + "fetchProducts.php", true);
        request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        // Prepare the request data
        console.log("Token: " + token);
        var requestData = "submit=&type=product&idProduct=" + encodeURIComponent(token) + "&idUser=" + encodeURIComponent(userID);

        // Handle the response
        request.onreadystatechange = function () {
            if (request.readyState === XMLHttpRequest.DONE) {
                var serverResponse = JSON.parse(request.responseText); // Parse the JSON response
                if (request.status === 200) {

                    // Request successful
                    // console.log("Response received:", request.responseText);
                    var data = serverResponse.data;

                    // Fill Product Data
                    fillProduct(data);
                } else {

                    // Request failed
                    console.log("Response received:", request.responseText);
                }
            }
        };

        // Send the request
        request.send(requestData);
    }

    // Seller Profile Image
    function fetchSellerImage() {
        var request = createRequest();

        // Set the request URL and method
        request.open("POST", configManager.getApisPath() + "imageManager.php", true);
        request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        // Prepare the request data
        var requestData = "submit=&type=fetch&idProduct=&idUser=" + encodeURIComponent(root.sellerID);

        // Handle the response
        request.onreadystatechange = function () {
            if (request.readyState === XMLHttpRequest.DONE) {
                var serverResponse = JSON.parse(request.responseText); // Parse the JSON response
                if (request.status === 200) {

                    // Request successful
                    // console.log("Response received:", request.responseText);
                    var data = JSON.parse(JSON.stringify(serverResponse.data));
                    console.log("Image Path: " + data[0].path.toString());

                    // Update the profile image
                    root.sellerProfileImage = data[0].path.toString();
                } else {

                    // Request failed
                    console.log("Response received:", request.responseText);
                }
            }
        };

        // Send the request
        request.send(requestData);
    }

    // Fill Products
    function fillProduct(data) {
        root.productID = data[0].id;
        root.imagePath = data[0].path;
        root.price = data[0].price;
        root.promo = data[0].sold;
        root.title = data[0].name;
        root.city = data[0].location;
        root.dateTime = data[0].dateAdd;
        root.descreption = data[0].description;
        root.categories= data[0].categories;
        // root.categories = "T-shirt, Sport";
        root.state = data[0].state;
        root.sellerID = data[0].idUser;
        root.sellerName = data[0].username;
        root.sellerPhoneNumber = data[0].tel;
        root.isOnline = true;
        root.isValidate = data[0].valid;
        followManager("isFollowed");
        root.isLiked = data[0].isLiked;

        // Fetch Seller Image
        if (root.sellerID != main.userID) {
            fetchSellerImage();
        } else {
            isMe = true;
        }
    }

    // Like Manager
    function likeManager(type) {
        var request = createRequest();

        // Set the request URL and method
        request.open("POST", configManager.getApisPath() + "likeManager.php", true);
        request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        // Prepare the request data
        console.log("Token: " + token);
        var requestData = "submit=&type=" + encodeURIComponent(type) + "&idProduct=" + encodeURIComponent(token) + "&idUser=" + encodeURIComponent(userID);

        // Handle the response
        request.onreadystatechange = function () {
            if (request.readyState === XMLHttpRequest.DONE) {
                var serverResponse = JSON.parse(request.responseText); // Parse the JSON response
                if (request.status === 200)

                // Request successful
                // console.log("Response received:", request.responseText);

                {
                } else {

                    // Request failed
                    console.log("Response failreceiveded:", request.responseText);
                }
            }
        };

        // Send the request
        request.send(requestData);
    }

    // Follower Manager
    function followManager(type) {
        var request = createRequest();

        // Set the request URL and method
        request.open("POST", configManager.getApisPath() + "followManager.php", true);
        request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        // Prepare the request data
        console.log("seller ID: " + sellerID + " user ID: " + userID);
        var requestData = "submit=&type=" + encodeURIComponent(type) + "&idSeller=" + encodeURIComponent(sellerID) + "&idUser=" + encodeURIComponent(userID);

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

    // Calculate Products
    function calculateProduct(price, promo) {
        return promo > 1 ? (price - (price * promo) / 100) : price;
    }

    Component.onCompleted: {
        initialize();
        myHeader.visible = false;
        myHeader.height = 0;
    }

    ScrollView {
        id: svContent

        width: root.width
        height: root.height
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff

        GridLayout {
            id: glContent

            width: root.width
            rowSpacing: 10
            columns: 1

            // Image Part
            Rectangle {
                id: imageSliderRec

                Layout.fillWidth: true
                height: 350
                color: "#e5e5e5"
                clip: true

                Image {
                    id: mainImage

                    source: main.urlTemp + root.imagePath
                    fillMode: Image.PreserveAspectFit
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: parent.height
                }

                RowLayout {
                    width: parent.width
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        margins: 10
                    }

                    MyIconButton {
                        id: returnButton

                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop

                        maIconButton.onClicked: {
                            stackView.pop();
                            myHeader.height = 50;
                            myHeader.visible = true;
                        }
                    }

                    RowLayout {
                        id: row

                        spacing: 10
                        Layout.alignment: Qt.AlignRight | Qt.AlignTop

                        // Comment Icon Button
                        MyIconButton {
                            id: commentButton

                            source: "qrc:/mainLib/icons/comment.svg"
                            visible: false
                        }

                        // Share Icon Button
                        MyIconButton {
                            id: shareButton

                            source: "qrc:/mainLib/icons/share_2.svg"
                        }

                        // Like Icon Button
                        MyIconButton {
                            id: likeButton

                            source: isLiked === true ? "qrc:/mainLib/icons/dislike.svg" : "qrc:/mainLib/icons/like.svg"

                            maIconButton.onClicked: {
                                if (!isLiked) {
                                    likeManager("add");
                                    isLiked = true;
                                } else {
                                    likeManager("delete");
                                    isLiked = false;
                                }
                            }
                        }
                    }
                }
            }

            // Slider Images
            RowLayout {
                id: slideRow

                spacing: 5
                Layout.alignment: Qt.AlignHCenter

                MySlideIcon {
                    id: activeIcon

                    isActive: true
                    color: "#000"
                }

                MySlideIcon {
                    id: mySlideIcon2

                    visible: false
                }
            }

            // Info Part
            ColumnLayout {
                id: columnLayout1

                Layout.fillWidth: true
                Layout.margins: 10
                spacing: 10
                clip: true

                // Price Text
                ColumnLayout {

                    Text {
                        id: oldPriceText

                        Layout.alignment: Qt.AlignRight
                        visible: root.promo > 1 ? true : false
                        text: root.price
                        font {
                            pixelSize: 20
                            family: "Texta"
                            styleName: "Thin Italic"
                            strikeout: true
                        }
                    }

                    RowLayout {

                        Text {
                            id: priceText

                            text: root.promo > 1 ? calculateProduct(root.price, root.promo) : root.price
                            font {
                                pixelSize: 35
                                family: "Texta"
                                styleName: "Black"
                            }
                            color: "#A45D00"
                        }

                        Text {
                            id: promoText

                            visible: root.promo > 1 ? true : false
                            font {
                                pixelSize: 15
                                family: "Texta"
                                styleName: "Italic"
                            }

                            color: "#646464"
                            text: qsTr("( " + root.promo + "% )")
                        }
                    }
                }

                // Title Text
                Text {
                    id: titleText

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    text: title
                    wrapMode: Text.WrapAnywhere
                    color: "#646464"
                    font {
                        pixelSize: 25
                        family: "Texta"
                        styleName: "Bold"
                    }

                    Component.onCompleted: {
                        width = contentWidth;
                    }
                }

                // City and Time
                RowLayout {
                    id: myIconsRec

                    height: myIconText.height
                    spacing: 20

                    MyIconText {
                        id: myIconText

                        Layout.alignment: Qt.AlignLeft
                        text: root.city
                    }

                    MyIconText {
                        id: myIconText1

                        Layout.alignment: Qt.AlignRight
                        source: "qrc:/mainLib/icons/date.svg"
                        text: root.dateTime
                    }
                }

                // Seller Number Button
                MyButton {
                    id: mbPhoneNumber

                    padding: 22
                    text: qsTr("Display Seller Number")

                    mouseArea.onClicked: {
                        dialogLoader.source = "components/MyDialog.qml";
                        dialogLoader.item.dialogDisplayNumberItem.open();
                    }
                }

                // Description
                Text {
                    id: descTitle

                    font {
                        family: "Texta"
                        pixelSize: 25
                        styleName: "Bold"
                    }
                    color: "#646464"
                    text: qsTr("Description")
                }

                Text {
                    id: descText

                    Layout.fillWidth: true
                    height: 80
                    color: "#646464"
                    text: root.descreption
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignTop
                }

                // Type and State
                RowLayout {
                    id: row1

                    spacing: 30
                    RowLayout {
                        id: typeRoow

                        spacing: 10

                        Text {
                            id: typeTitle

                            font {
                                family: "Texta"
                                styleName: "Bold"
                                pixelSize: 25
                            }
                            color: "#646464"
                            text: qsTr("Type")
                        }

                        Text {
                            id: typeNames

                            text: root.categories
                            font.pixelSize: 15
                            font.family: "Texta"
                            font.styleName: "Regular"
                            color: "#646464"
                        }
                    }

                    RowLayout {
                        id: stateRow

                        spacing: 10

                        Text {
                            id: stateTitle

                            font {
                                family: "Texta"
                                styleName: "Bold"
                                pixelSize: 25
                            }
                            color: "#646464"
                            text: qsTr("State")
                        }

                        Text {
                            id: stateNames

                            text: root.state === "1" ? "New" : "Old"
                            font.pixelSize: 15
                            font.family: "Texta"
                            font.styleName: "Regular"
                            color: "#646464"
                            anchors.verticalCenter: stateTitle.verticalCenter
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    // Profile Pic Wrapper
                    MyProfileWrapper {
                        id: profileWrapper

                        width: 100
                        height: 100
                        isOnline: root.isOnline
                        isValidate: root.isValidate
                        source: main.userID === parseInt(root.sellerID) ? main.profileImage !== "" ? main.urlTemp + main.profileImage : "qrc:/mainLib/images/Profile_Pic_Circle.png" : root.sellerProfileImage !== "" ? main.urlTemp + root.sellerProfileImage : "qrc:/mainLib/images/Profile_Pic_Circle.png"
                        maWrapper.onClicked: {
                            main.token = root.sellerID;
                            stackView.push("UserPage.qml");
                            console.log("Wraper Clicked");
                        }
                    }

                    // Username
                    Text {
                        id: tfUserName

                        Layout.fillWidth: true
                        text: root.sellerName
                        font {
                            pixelSize: 25
                            family: "Texta"
                            styleName: "Black"
                        }
                    }
                }

                // Follow and Message Buttons
                RowLayout {
                    id: rlContactSeller

                    Layout.alignment: Qt.AlignHCenter
                    spacing: 10
                    visible: root.sellerID == main.userID ? false : true

                    MyButton {
                        id: followButton

                        padding: 5
                        text: root.isFollowed == true ? qsTr("Followed") : qsTr("Follow")

                        mouseArea.onClicked: {
                            if (isFollowed == true) {
                                followManager("delete");
                                followButton.text = "Follow";
                                isFollowed = false;
                            } else {
                                followManager("add");
                                followButton.text = "Followed";
                                isFollowed = true;
                            }
                        }
                    }

                    MyButton {
                        id: messageButton

                        padding: 5
                        text: qsTr("Message")

                        mouseArea.onClicked: {
                            dialogLoader.source = "components/MyDialog.qml";
                            dialogLoader.item.dialogMessageItem.open();
                        }
                    }
                }

                // About Me
                ColumnLayout {
                    id: rlAboutMe

                    Layout.alignment: Qt.AlignHCenter
                    spacing: 5

                    Text {
                        id: txAboutMe

                        font {
                            family: "Texta"
                            pixelSize: 25
                            styleName: "Bold"
                        }
                        color: "#646464"
                        text: qsTr("About Me")
                    }

                    Text {
                        id: txAboutMeDescription

                        Layout.fillWidth: true
                        color: "#646464"
                        text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignTop
                    }
                }

                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    height: 1
                    color: "#707070"
                    Image {
                        source: ""
                        fillMode: Image.PreserveAspectFit
                    }
                }

                // Report Text
                Rectangle {

                    width: 80
                    height: 80
                    color: "transparent"
                    Layout.alignment: Qt.AlignHCenter

                    Image {
                        id: reportImage

                        anchors.fill: parent
                        source: "qrc:/mainLib/icons/exclamation_mark.svg"
                        fillMode: Image.PreserveAspectFit
                    }
                }

                Text {
                    id: reportText

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignTop
                    text: "Tiflet Store is not responsible for the products offered in the advertisements."
                    font {
                        pixelSize: 25
                        styleName: "Bold"
                        family: "Texta"
                    }
                }

                MyButton {
                    id: reportButton

                    Layout.alignment: Qt.AlignHCenter
                    padding: 10
                    buttonBody.border.color: "#FF0000"
                    text: qsTr("REPORT")
                    color: "#FF0000"
                    buttonText.font {
                        pixelSize: 25
                        styleName: "Bold"
                        family: "Texta"
                    }

                    mouseArea.onClicked: {
                        dialogLoader.source = "components/MyDialog.qml";
                        dialogLoader.item.dialogReportItem.open();
                    }
                }

                //Report Button
                Rectangle {
                    Layout.fillWidth: true
                    height: 5
                    color: "#707070"
                    opacity: 0
                    Image {
                        source: ""
                        fillMode: Image.PreserveAspectFit
                    }
                }
            }
        }
    }

    Loader {
        id: dialogLoader

        anchors.fill: parent
    }
}
