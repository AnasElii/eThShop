import QtQuick
import QtQuick.Controls

TabBar {
    TabButton {
        text: "Home"
        display: Qt.ToolButtonTextUnderIcon
        icon.source: "qrc:/mainLib/icons/home.png"

        onClicked: root.stackView.replace("HomePage.qml")
    }

   TabButton {
       text: "List"
       display: Qt.ToolButtonTextUnderIcon
       icon.source: "qrc:/mainLib/icons/list.png"
   }

   TabButton {
       text: "Add"
       display: Qt.ToolButtonTextUnderIcon
       icon.source: "qrc:/mainLib/icons/add-new.png"
   }

   TabButton {
       text: "User"
       display: Qt.ToolButtonTextUnderIcon
       icon.source: "qrc:/mainLib/icons/user.png"
   }

    TabButton {
        text: "Settings"
        display: Qt.ToolButtonTextUnderIcon
        icon.source: "qrc:/mainLib/icons/settings.png"

        onClicked: root.stackView.replace("SettingsPage.qml")

    }
}
