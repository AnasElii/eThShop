import QtQuick
import QtQuick.Controls

ToolBar {
    id: toolBar

    width: parent.width
    anchors.top: parent.top

    property Flickable flickable
    property StackView stackView: main.stackView
    property Popup popup
    property var previousPage: stackView.get(parent.StackView.index - 1)

    property alias addNewButton : addNewButton
    property alias editingFinishedButton : editingFinishedButton

    background.visible: flickable.atYBeginning

    // Back Button
    ToolButton{
        anchors.left: parent.left
        display: Qt.ToolButtonTextBesideIcon
        icon.source: "qrc:/mainLib/icons/stackview-backarrow-light@2x.png"

        visible: toolBar.stackView.depth > 1
        text: toolBar.previousPage ? toolBar.previousPage.title : ""
        onClicked: toolBar.stackView.pop()
    }

    // Title
    Label{
        anchors.centerIn: parent
        font.styleName: "Semibold"

        text: toolBar.stackView.currentItem.title
        visible: toolBar.background.visible
    }

    // Action Button
    ToolButton{
        id: addNewButton

        anchors.right: parent.right
        display: Qt.ToolButtonTextBesideIcon
        icon.source: "qrc:/mainLib/icons/add-new.png"

        onClicked: toolBar.popup.open();
    } 

    ToolButton{
        id: editingFinishedButton

        display: Qt.ToolButtonTextOnly
        text: qsTr("Done")
        visible: false
        anchors.right: parent.right
    }

}
