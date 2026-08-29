import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import ovras.advsettings 1.0
import "../../../common"
import "." // QTBUG-34418, singletons require explicit import to load qmldir file
GroupBox {
    id: chaperoneMiscGroupBox
    Layout.fillWidth: true

    label: MyText {
        leftPadding: 10
        text: "杂项:"
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

        RowLayout {
            spacing: 16

            MyToggleButton {
                id: chaperoneFloorToggleBtn
                text: "始终显示地面边界"
                Layout.preferredWidth: 375
                onCheckedChanged: {
                    ChaperoneTabController.setChaperoneFloorToggle(this.checked, false)
                }
            }


            MyToggleButton {
                id: legacyCenterMarkerbtn
                text: "旧版中心标记"
                Layout.preferredWidth: 375
                onCheckedChanged: {
                    ChaperoneTabController.setCenterMarker(this.checked, false)
                }
            }

            MyPushButton{
                id:btnResetOrientation
                text: "重置旋转计数器"
                onClicked: {
                    StatisticsTabController.statsRotationResetClicked()
                }
            }

        }

    }

    Component.onCompleted: {
            chaperoneFloorToggleBtn.checked = ChaperoneTabController.chaperoneFloorToggle
            legacyCenterMarkerbtn.checked = ChaperoneTabController.centerMarker
    }

    Connections {
        target: ChaperoneTabController
        onChaperoneFloorToggleChanged:{
            chaperoneFloorToggleBtn.checked = ChaperoneTabController.chaperoneFloorToggle
        }
        onCenterMarkerChanged:{
            legacyCenterMarkerbtn.checked = ChaperoneTabController.centerMarker
        }
    }
}
