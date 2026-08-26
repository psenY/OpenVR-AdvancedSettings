import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import ovras.advsettings 1.0
import "../../common"

GroupBox {
    id: steamVRMiscGroupBox
    Layout.fillWidth: true

    label: MyText {
        leftPadding: 10
        text: qsTr("Misc:")
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
                id: steamvrPerformanceGraphToggle
                text: qsTr("Enable Timing Overlay")
                Layout.preferredWidth: 300
                onCheckedChanged: {
                    SteamVRTabController.setPerformanceGraph(this.checked, false)
                }
            }
            MyText {
                Layout.preferredWidth: 20
                text: " "
            }
            MyToggleButton {
                id: steamvrNoHMDToggle
                text: qsTr("Require HMD")
                Layout.preferredWidth: 300
                onCheckedChanged: {
                    SteamVRTabController.setNoHMD(this.checked, false)
                }
            }
            MyText {
                Layout.preferredWidth: 20
                text: " "
            }
            MyToggleButton {
                id: steamvrNoFadeToGridToggle
                Layout.fillWidth: true
                text: qsTr("No Fade to Grid")
                onCheckedChanged: {
                    SteamVRTabController.setNoFadeToGrid(this.checked, false)
                }
            }
        }
        RowLayout {
            spacing: 16

            MyToggleButton {
                id: steamvrMultipleDriverToggle
                Layout.preferredWidth: 300
                text: qsTr("Allow Multiple Drivers")
                onCheckedChanged: {
                    SteamVRTabController.setMultipleDriver(this.checked, false)
                }
            }
            MyText {
                Layout.preferredWidth: 20
                text: " "
            }
            MyToggleButton {
                id: steamvrSystemButtonToggle
                Layout.fillWidth: true
                text: qsTr("Enable System Button Binding")
                onCheckedChanged: {
                    SteamVRTabController.setSystemButton(this.checked, false)
                }
            }

        }

        RowLayout {
            spacing: 16

            MyToggleButton {
                id: steamvrNotificationToggle
                text: qsTr("Disable Notifications")
                 Layout.preferredWidth: 300
                onCheckedChanged: {
                    SteamVRTabController.setDND(this.checked, false)
                }
            }
            MyText {
                Layout.preferredWidth: 20
                text: " "
            }
            MyToggleButton {
                id: steamvrControllerPowerToggle
                Layout.fillWidth: true
                text: qsTr("Controller Power Turns on SteamVR")
                onCheckedChanged: {
                    SteamVRTabController.setControllerPower(this.checked, false)
                }
            }

        }

    }

    Component.onCompleted: {
            steamvrPerformanceGraphToggle.checked = SteamVRTabController.performanceGraph
        steamvrSystemButtonToggle.checked = SteamVRTabController.systemButton
        steamvrMultipleDriverToggle.checked = SteamVRTabController.multipleDriver
        steamvrNoFadeToGridToggle.checked = SteamVRTabController.noFadeToGrid
        steamvrNotificationToggle.checked = SteamVRTabController.dnd
        steamvrControllerPowerToggle.checked = SteamVRTabController.controllerPower
        steamvrNoHMDToggle.checked = SteamVRTabController.noHMD
    }

    Connections {
        target: SteamVRTabController
        onPerformanceGraphChanged:{
            steamvrPerformanceGraphToggle.checked = SteamVRTabController.performanceGraph
        }
        onSystemButtonChanged:{
            steamvrSystemButtonToggle.checked = SteamVRTabController.systemButton
        }
        onMultipleDriverChanged:{
            steamvrMultipleDriverToggle.checked = SteamVRTabController.multipleDriver
        }
        onNoFadeToGridChanged:{
            steamvrNoFadeToGridToggle.checked = SteamVRTabController.noFadeToGrid
        }
        onDNDChanged:{
            steamvrNotificationToggle.checked = SteamVRTabController.dnd
        }
        onNoHMDChanged:{
            steamvrNoHMDToggle.checked = SteamVRTabController.noHMD
        }
        onControllerPowerChanged:{
            steamvrControllerPowerToggle.checked = SteamVRTabController.controllerPower
        }

    }
}
