import QtQuick 6.5
import Qt.labs.platform

Item {
    id: root

    property MessageDialog deleteMessageDialog: MessageDialog{
        id: deletemessageDialog
        text: ""
        informativeText: "Do you want to save your changes?"
        buttons: MessageDialog.Ok | MessageDialog.Cancel
    }

    property MessageDialog addProductMessageDialog: MessageDialog{
        id: addMessageDialog
        text: "Product Added Successfully"
        buttons: MessageDialog.Ok
    }

    property FileDialog uploadProductImagesDialog: FileDialog{
        id: fdProductImages
        fileMode: FileDialog.OpenFiles
        folder: StandardPaths.writableLocation(StandardPaths.PicturesLocation)

        onAccepted: {
            // Handle the accepted files here
            main.imageSource = [];
            main.imageSource = fdProductImages.files
        }
    }

    property FileDialog uploadProfileImageDialog: FileDialog{
        id: fdProfileImage
        fileMode: FileDialog.OpenFile
        folder: StandardPaths.writableLocation(StandardPaths.PicturesLocation)
        nameFilters: ["Image Files (*.png *.jpeg *.jpg)", "(*.png)", "(*.jpeg *.jpg)"]
        
        onAccepted: {
            // Handle the accepted files here
            main.profileImageTemp = "";
            main.profileImageTemp = fdProfileImage.file
        }
    }

    property MessageDialog profileImageErrorMessageDialog: MessageDialog{
        id: fdProfileErrorMessage
        text: "Select Profile Image"
        buttons: MessageDialog.Ok
    }
}
