import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import ovras.advsettings 1.0
import "../../../common"
import "." // QTBUG-34418, singletons require explicit import to load qmldir file

GroupBox {
    id: chaperoneTypeGroupBox
    Layout.fillWidth: true

    label: MyText {
        leftPadding: 10
        text: "边界样式"
        bottomPadding: -10
    }
    background: Rectangle {
        color: "transparent"
        border.color: "#d9dbe0"
        radius: 8
    }

    ColumnLayout {
        anchors.fill: parent

        Rectangle {
            color: "#d9dbe0"
            height: 1
            Layout.fillWidth: true
            Layout.bottomMargin: 5
        }

            RowLayout{
                ButtonGroup { id: chaperoneTypeExclGroup
                exclusive: true}
                MyRadioButton {
                    id: denseRadio
                    text: qsTr("密集")
                    ButtonGroup.group: chaperoneTypeExclGroup
                    Layout.preferredWidth: 200
                    onCheckedChanged: {
                        if(checked){
                            MyResources.playActivationSound()
                            ChaperoneTabController.setCollisionBoundStyle(0)
                        }
                    }
                }
                MyRadioButton {
                    id: medRadio
                    text: qsTr("中等")
                    ButtonGroup.group: chaperoneTypeExclGroup
                    Layout.preferredWidth: 200
                    onCheckedChanged: {
                        if(checked){
                            MyResources.playActivationSound()
                            ChaperoneTabController.setCollisionBoundStyle(1)
                        }
                    }
                }
                MyRadioButton {
                    id: squaresRadio
                    text: qsTr("方格")
                    ButtonGroup.group: chaperoneTypeExclGroup
                    Layout.preferredWidth: 200
                    onCheckedChanged: {
                        if(checked){
                            MyResources.playActivationSound()
                            ChaperoneTabController.setCollisionBoundStyle(2)
                        }
                    }
                }
                MyRadioButton {
                    id: sparseRadio
                    text: qsTr("稀疏")
                    ButtonGroup.group: chaperoneTypeExclGroup
                    Layout.preferredWidth: 200
                    onCheckedChanged: {
                        if(checked){
                            MyResources.playActivationSound()
                            ChaperoneTabController.setCollisionBoundStyle(3)
                        }
                    }
                }
                MyRadioButton {
                    id: floorRadio
                    text: qsTr("仅地面")
                    ButtonGroup.group: chaperoneTypeExclGroup
                    Layout.preferredWidth: 200
                    onCheckedChanged: {
                        if(checked){
                            MyResources.playActivationSound()
                            ChaperoneTabController.setCollisionBoundStyle(4)
                        }
                    }
                }
            }


    }
    Component.onCompleted: {
        // set up var here to prevent double call to c++ from qml
        var collisiontype = ChaperoneTabController.collisionBoundStyle
        switch(collisiontype){
        case 0: denseRadio.checked = true; break;
        case 1: medRadio.checked = true; break;
        case 2: squaresRadio.checked = true; break;
        case 3: sparseRadio.checked = true; break
        case 4: floorRadio.checked = true; break;
        }

    }

    Connections {
        target: ChaperoneTabController
        onCollisionBoundStyleChanged:{
            var collisiontype = ChaperoneTabController.collisionBoundStyle
            switch(collisiontype){
            case 0: denseRadio.checked = true; break;
            case 1: medRadio.checked = true; break;
            case 2: squaresRadio.checked = true; break;
            case 3: sparseRadio.checked = true; break
            case 4: floorRadio.checked = true; break;
            }
        }

    }
}
