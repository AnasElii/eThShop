import QtQuick 6.5
import Qt.labs.platform
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5
import QtQuick.Effects 6.5
import QtWebSockets
import mainLib 1.0
import "components"

Item {
    id: root

    property string idProduct: ""
    property var category: []
    property var images: []

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.margins: 10

    Connections {
        target: fImageUploader
        
        function onReplyExecuted() {

            //MARK: CLEAR INPUTS AND FIELDS
            main.updateProductInfo = [];
            main.isEditable = false;
            main.imageSource = [];
            root.idProduct = "";
            root.images = [];
                        
            //MARK: DISPLAY HEADER
            myHeader.visible = true;
            myHeader.height = 50;
            myHeader.isHomePage = true;

            //MARK: GO BACK TO HOMEPAGE
            stackView.pop("AddProductPage.qml");
            stackView.pop("AddProductS2Page.qml");
            main.imageSource = [];
            stackView.push("HomePage.qml");
            
        }
    }

    function productManger(type) {
        var request = createRequest();

        // Set the request URL and method
        request.open("POST", url + "api/productManager.php", true);
        request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        // Prepare the request data
        var requestData = "submit=&type=" + encodeURIComponent(type) + 
        "&name=" + encodeURIComponent(main.productInfo[0].name) +
        "&price=" + encodeURIComponent(main.productInfo[0].price) +
        "&promo=" + encodeURIComponent(main.productInfo[0].promo) +
        "&description=" + encodeURIComponent(main.productInfo[0].description) +
        "&state=" + encodeURIComponent(main.productInfo[0].state) +   
        "&idUser=" + encodeURIComponent(main.userID);
        
        if(type === "update")
            requestData += "&idProduct=" + encodeURIComponent(root.idProduct);
            
        // Handle the response
        request.onreadystatechange = function () {
            if (request.readyState === XMLHttpRequest.DONE) {

                // Parse the JSON response
                var serverResponse = JSON.parse(request.responseText);
                if (request.status === 200) {

                    // Request successful
                    console.log("Response received:", request.responseText);
                    

                    if(type === "add"){
                    
                        root.idProduct = serverResponse.data.toString();
                        if(root.idProduct !== ""){
                            fImageUploader.uploadImages(main.imageSource, "addImages", root.idProduct);
                            fCategoryManager.manageProductCategory(cbCategory.currentValue , root.idProduct);
                        }
                    
                    } if(type === "update"){

                        //MARK: CHECK IF IMAGES CHANGED
                        for(var i = 0; i < main.imageSource.length; i++){
                            for(var j = 0; j < main.updateProductInfo.images.length; j++){
                                if(main.imageSource[i] === main.updateProductInfo.images[j].path.toString()){
                                    root.images.push(main.updateProductInfo.images[j].path.toString());
                                    continue;
                                }
                            }
                        }

                        if(root.images.length < main.imageSource.length){
                            //MARK: UPLOAD NEW IMAGES
                            fImageUploader.uploadImages(main.imageSource, "updateImages", root.idProduct);
                        }

                        //MARK: CHECK IF THE CATEGORY CHANGED
                        if(root.category.idCategory !== cbCategory.currentValue){
                            fCategoryManager.manageProductCategory(root.category.id.toString(), cbCategory.currentValue.toString(), root.idProduct);
                        }
                    }
                    
                } else {

                    // Request failed
                    console.log("Response error:", request.responseText);
                }

            }
        };

        // Send the request
        request.send(requestData);
    }

    Component.onCompleted: {
        myHeader.visible = false;
        myHeader.height = 0;

        var categoryList = fCategoryManager.getCategories();
        // for(var i = 0; i < categoryList.length; i++){
        //     var category = categoryList[i];
        //     console.log("Category: " + category.name);
        // }

        cbCategory.model = categoryList;

        if(isEditable){
            textTitle.text = qsTr("Updte Product");
            btnNext.text = qsTr("Update");
            btnNext.highlighted = false;

            root.category = main.updateProductInfo.category[0];
            cbCategory.currentIndex = cbCategory.indexOfValue(root.category.idCategory);
            cbState.currentIndex = parseInt(main.updateProductInfo.state);
            root.idProduct = main.updateProductInfo.id.toString();

            var imageHolders =[
                imageHolder1,
                imageHolder2,
                imageHolder3
            ]

            for(var i = 0; i < main.updateProductInfo.images.length; i++){
                main.imageSource.push(main.updateProductInfo.images[i].path.toString());
            } 

            for(var i = 0; i < main.imageSource.length; i++){
                imageHolders[i].source = main.urlTemp + main.imageSource[i];
            }      
        }
    }

    function updateImageHolders(){
        var imageHolders =[
            imageHolder1,
            imageHolder2,
            imageHolder3
        ]

        
        for(var i = 0; i < imageHolders.length; i++){
            imageHolders[i].source = "";
        }  

        // if(main.isEditable)
            for(var i = 0; i < main.imageSource.length; i++){
                imageHolders[i].source = main.imageSource[i];
            }   

    }

    function addProductImages(){
        console.log("Add Product Images");
        main.imageSource = [];
        main.imageSource = customDialogLoader.item.uploadProductImagesDialog.files

        updateImageHolders();
    }

    FImageUploader {
        id: fImageUploader
    }

    ScrollView {
        id: svContent

        anchors.fill: parent

        contentChildren: Rectangle {
            id: background

            width: parent.width
            height: gridInput.height + 40
            anchors.centerIn: parent
            color: "#FFFFFF"
            z: -1
            radius: 10

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowBlur: .6
                shadowVerticalOffset: 5
                shadowOpacity: .5
            }

            GridLayout {
                id: gridInput

                width: parent.width - 20
                anchors.centerIn: parent
                columns: 2
                columnSpacing: 20
                rowSpacing: 20

                Text {
                    id: textTitle

                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillHeight: true
                    Layout.columnSpan: 2

                    text: qsTr("Add Product")
                    font {
                        pixelSize: 50
                        family: "Source Sans Pro"
                        styleName: "Bold"
                    }
                    color: "#000000"
                }

                MyStepBar {
                    id: stepbar

                    Layout.columnSpan: 2
                    Layout.alignment: Qt.AlignHCenter
                    step: 2
                }

                ColumnLayout {
                    Layout.columnSpan: 2
                    Layout.fillWidth: true

                    Label {
                        id: lbImages

                        text: qsTr("Add Images")
                        font.pixelSize: 25
                        font.family: "Texta"
                    }
                    MyImageUploadItem {
                        id: imageUpload

                        Layout.fillWidth: true
                        maImageUpload.onClicked: {
                            //MARK: DESPLAY MESSAGE
                            customDialogLoader.source = "components/MyCustomDialog.qml"
                            customDialogLoader.item.uploadProductImagesDialog.onAccepted.connect(addProductImages)
                            customDialogLoader.item.uploadProductImagesDialog.open()

                            //MARK: CLEAR ERROR FLAGS
                            imageUpload.strokeColor = "black";
                            imageUpload.color = "transparent";
                        }
                    }

                    RowLayout {
                        spacing: 5
                        Layout.fillWidth: true

                        MyImageHolder {
                            id: imageHolder1

                            Layout.alignment: Qt.AlignLeft
                            source: main.imageSource.length >= 1 ? main.imageSource[0] : ""
                        }

                        MyImageHolder {
                            id: imageHolder2

                            Layout.alignment: Qt.AlignHCenter
                            source: main.imageSource.length >= 2 ? main.imageSource[1] : ""
                        }

                        MyImageHolder {
                            id: imageHolder3

                            Layout.alignment: Qt.AlignRight
                            source: main.imageSource.length >= 3 ? main.imageSource[2] : ""
                        }
                    }
                }

                RowLayout {
                    id: rlPriceAndPromo

                    Layout.columnSpan: 2

                    ColumnLayout {
                        Label {
                            id: lbCategory

                            text: qsTr("Category")
                            font.pixelSize: 25
                            font.family: "Texta"
                        }
                        ComboBox {
                            id: cbCategory

                            Layout.fillWidth: true
                            textRole: "name"
                            valueRole: "id"
                            currentIndex: parseInt(model.id);
                            
                            font.pixelSize: 16

                            onActivated: {
                                console.log("Category ID From Value: " + currentValue);
                            }

                        }
                    }

                    ColumnLayout {
                        Label {
                            id: lbState

                            text: qsTr("State")
                            font.pixelSize: 25
                            font.family: "Texta"
                        }
                        ComboBox {
                            id: cbState

                            Layout.fillWidth: true
                            model: ["New", "Good Condition"]
                            font.pixelSize: 16
                        }
                    }
                }

                RowLayout {
                    spacing: 5

                    Layout.columnSpan: 2
                    Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                    Layout.margins: 10

                    Button {
                        id: btnPreview

                        text: "Previous"
                        flat: true

                        onClicked: {
                            stackView.pop();
                        }
                    }

                    Button {
                        id: btnCancle

                        text: "Cancle"
                        flat: true

                        onClicked: {
                            if(main.isEditable){
                                main.isEditable = false;
                                main.updateProductInfo = [];
                            }

                            main.imageSource = [];

                            stackView.pop("AddProductPage.qml");
                            stackView.pop("AddProductS2Page.qml");
                            stackView.push("HomePage.qml");

                            // Display The Header
                            myHeader.visible = true;
                            myHeader.height = 50;
                        }
                    }

                    Button {
                        id: btnNext

                        text: "Add"
                        highlighted: true

                        onClicked: {

                            //MARK: CHECK INPUTS
                            if (cbCategory.currentText === "" || cbState.currentText === "") {
                                console.log("Please fill all the fields");
                            }

                            //MARK: CHECK IMAGES
                            else if (main.imageSource.length === 0) {
                                imageUpload.strokeColor = "red";
                                imageUpload.color = "#f99bda";
                                return;
                            }

                            //MARK: EDIT PRODUCT AND GO BACK TO HOMEPAGE
                            var productInfoP1 = main.productInfo;
                            var productInfoP2 = {
                                "category": cbCategory.currentText,
                                "state": (cbState.currentIndex).toString(),
                            };
                           
                            main.productInfo = [];

                            var combaindProductInfo = Object.assign(productInfoP1, productInfoP2);
                            main.productInfo.push(combaindProductInfo);
                            
                            if(isEditable){
                                productManger("update");
                            }
                            else{
                                productManger("add");
                            }

                            //MARK: DESPLAY MESSAGE
                            // customDialogLoader.source = "components/MyCustomDialog.qml"
                            // if(isEditable)
                            //     customDialogLoader.item.addProductMessageDialog.text = "Product Updated Successfully";
                            // else
                            //     customDialogLoader.item.addProductMessageDialog.text = "Product Added Successfully";
                            // customDialogLoader.item.addProductMessageDialog.open()
                        }
                    }
                }
            }
        }
    }
}
