import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import ovras.advsettings 1.0
import "common"


MyStackViewPage {
    headerText: "空间偏移"

    MyDialogOkPopup {
        id: offsetMessageDialog
        function showMessage(title, text) {
            dialogTitle = title
            dialogText = text
            open()
        }
    }

    MyDialogOkCancelPopup {
        id: offsetDeleteProfileDialog
        property int profileIndex: -1
        dialogTitle: "删除配置文件"
        dialogText: "您确定要删除此配置文件吗？"
        onClosed: {
            if (okClicked) {
                MoveCenterTabController.deleteOffsetProfile(profileIndex)
            }
        }
    }

    MyDialogOkCancelPopup {
        id: offsetNewProfileDialog
        dialogTitle: "新建配置文件"
        dialogWidth: 800
        dialogHeight: 400
        dialogContentItem: ColumnLayout {
            RowLayout {
                Layout.topMargin: 16
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                MyText {
                    text: "名称: "
                }
                MyTextField {
                    id: offsetNewProfileName
                    keyBoardUID: 105
                    color: "#cccccc"
                    text: ""
                    Layout.fillWidth: true
                    font.pointSize: 20
                    function onInputEvent(input) {
                        offsetNewProfileName.text = input
                    }
                }
            }
        }
        onClosed: {
            if (okClicked) {
                if (offsetNewProfileName.text == "") {
                    offsetMessageDialog.showMessage("Create New Profile", "ERROR: Empty profile name.")
                } else {
                    MoveCenterTabController.addOffsetProfile(offsetNewProfileName.text)
                }

            }
        }
        function openPopup() {
            offsetNewProfileName.text = ""
            open()
        }
    }

    content: ColumnLayout {
        spacing: 18

        RowLayout {
            MyText {
                text: "追踪空间:"
                Layout.preferredWidth: 230
            }
            MyText {
                id: spaceModeText
                font.bold: true
                text: "站姿"
            }
        }

        ColumnLayout {
            id: profileSection
            Layout.bottomMargin: 32
            spacing: 18
            RowLayout {
                spacing: 18

                MyText {
                    text: "配置文件:"
                }

                MyComboBox {
                    id: offsetProfileComboBox
                    Layout.maximumWidth: 799
                    Layout.minimumWidth: 799
                    Layout.preferredWidth: 799
                    Layout.fillWidth: true
                    model: [""]
                    onCurrentIndexChanged: {
                        if (currentIndex > 0) {
                            offsetApplyProfileButton.enabled = true
                            offsetDeleteProfileButton.enabled = true
                        } else {
                            offsetApplyProfileButton.enabled = false
                            offsetDeleteProfileButton.enabled = false
                        }
                    }
                }

                MyPushButton {
                    id: offsetApplyProfileButton
                    enabled: false
                    Layout.preferredWidth: 200
                    text: "应用"
                    onClicked: {
                        if (offsetProfileComboBox.currentIndex > 0) {
                            MoveCenterTabController.applyOffsetProfile(offsetProfileComboBox.currentIndex - 1)
                            offsetProfileComboBox.currentIndex = 0
                        }
                    }
                }
            }
            RowLayout {
                spacing: 18
                Item {
                    Layout.fillWidth: true
                }
                MyPushButton {
                    id: offsetDeleteProfileButton
                    enabled: false
                    Layout.preferredWidth: 200
                    text: "删除配置文件"
                    onClicked: {
                        if (offsetProfileComboBox.currentIndex > 0) {
                            offsetDeleteProfileDialog.profileIndex = offsetProfileComboBox.currentIndex - 1
                            offsetDeleteProfileDialog.open()
                        }
                    }
                }
                MyPushButton {
                    Layout.preferredWidth: 200
                    text: "新建配置文件"
                    onClicked: {
                        offsetNewProfileDialog.openPopup()
                    }
                }
            }
        }

        GroupBox {
            Layout.fillWidth: true
            id: offsetsGroupBox
            visible: true

            label: MyText {
                leftPadding: 10
                text: "移动空间"
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

                GridLayout {
                    columns: 6

                    MyText {
                        text: "X 轴（左/右）:"
                        Layout.preferredWidth: 340
                    }

                    MyText {
                        text: " "
                        Layout.preferredWidth: 40
                    }

                    MyPushButton2 {
                        id: spaceMoveXMinusButton
                        Layout.preferredWidth: 40
                        text: "-"
                        onClicked: {
                            MoveCenterTabController.modOffsetX(-0.1)
                        }
                    }

					MyTextField {
                        id: spaceMoveXText
                        text: "0.00"
						keyBoardUID: 101
                        Layout.preferredWidth: 140
                        Layout.leftMargin: 10
                        Layout.rightMargin: 10
                        horizontalAlignment: Text.AlignHCenter
                        function onInputEvent(input) {
                            var val = parseFloat(input)
                            if (!isNaN(val)) {
                                MoveCenterTabController.offsetX = val.toFixed(2)
                                text = MoveCenterTabController.offsetX.toFixed(2)
                            } else {
                                text = MoveCenterTabController.offsetX.toFixed(2)
                            }
                        }
                    }

                    MyPushButton2 {
                        id: spaceMoveXPlusButton
                        Layout.preferredWidth: 40
                        text: "+"
                        onClicked: {
                            MoveCenterTabController.modOffsetX(0.1)
                        }
                    }

                    MyToggleButton {
                        id: lockXToggle
                        text: "锁定 X 轴"
                        onCheckedChanged: {
                            MoveCenterTabController.lockXToggle = this.checked
                        }
                    }

                    MyText {
                        text: "Y 轴（上/下）:"
                        Layout.preferredWidth: 340
                    }

                    MyPushButton2 {
                        Layout.preferredWidth: 40
                        text: "0"
                        onClicked: {
                            MoveCenterTabController.offsetY = 0
                        }
                    }

                    MyPushButton2 {
                        Layout.preferredWidth: 40
                        text: "-"
                        onClicked: {
                            MoveCenterTabController.modOffsetY(-0.1)
                        }
                    }

                    MyTextField {
                        id: spaceMoveYText
                        text: "0.00"
                        keyBoardUID: 102
                        Layout.preferredWidth: 140
                        Layout.leftMargin: 10
                        Layout.rightMargin: 10
                        horizontalAlignment: Text.AlignHCenter
                        function onInputEvent(input) {
                            var val = parseFloat(input)
                            if (!isNaN(val)) {
                                MoveCenterTabController.offsetY = val.toFixed(2)
                                text = MoveCenterTabController.offsetY.toFixed(2)
                            } else {
                                text = MoveCenterTabController.offsetY.toFixed(2)
                            }
                        }
                    }

                    MyPushButton2 {
                        Layout.preferredWidth: 40
                        text: "+"
                        onClicked: {
                            MoveCenterTabController.modOffsetY(0.1)
                        }
                    }


                    MyToggleButton {
                        id: lockYToggle
                        text: "锁定 Y 轴"
                        onCheckedChanged: {
                            MoveCenterTabController.lockYToggle = this.checked
                        }
                    }

                    MyText {
                        text: "Z 轴（前/后）:"
                        Layout.preferredWidth: 340
                    }

                    MyText {
                        text: " "
                        Layout.preferredWidth: 40
                    }

                    MyPushButton2 {
                        Layout.preferredWidth: 40
                        text: "-"
                        onClicked: {
                            MoveCenterTabController.modOffsetZ(-0.1)
                        }
                    }

                    MyTextField {
                        id: spaceMoveZText
                        text: "0.00"
                        keyBoardUID: 103
                        Layout.preferredWidth: 140
                        Layout.leftMargin: 10
                        Layout.rightMargin: 10
                        horizontalAlignment: Text.AlignHCenter
                        function onInputEvent(input) {
                            var val = parseFloat(input)
                            if (!isNaN(val)) {
                                MoveCenterTabController.offsetZ = val.toFixed(2)
                                text = MoveCenterTabController.offsetZ.toFixed(2)
                            } else {
                                text = MoveCenterTabController.offsetZ.toFixed(2)
                            }
                        }
                    }

                    MyPushButton2 {
                        Layout.preferredWidth: 40
                        text: "+"
                        onClicked: {
                            MoveCenterTabController.modOffsetZ(0.1)
                        }
                    }


                    MyToggleButton {
                        id: lockZToggle
                        text: "锁定 Z 轴"
                        onCheckedChanged: {
                            MoveCenterTabController.lockZToggle = this.checked
                        }
                    }
                }
            }
        }

        GroupBox {
            Layout.fillWidth: true
            id: rotationGroupBox
            visible: true

            label: MyText {
                leftPadding: 10
                text: "旋转空间"
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

                ColumnLayout {
                    RowLayout {
                        MyPushButton2 {
                            id: spaceRotationMinusButton
                            Layout.preferredWidth: 40
                            text: "-"
                            onClicked: {
                                var val = ( MoveCenterTabController.tempRotation / 100 ) - 45
                                if (val < -180) {
                                    val = val + 360;
                                }
                                MoveCenterTabController.tempRotation = val * 100
                            }
                        }

                        MySlider {
                            id: spaceRotationSlider
                            from: -180
                            to: 180
                            stepSize: 0.01
                            value: 0
                            Layout.fillWidth: true
                            onPositionChanged: {
                                var val = this.from + ( this.position  * (this.to - this.from))
                                MoveCenterTabController.tempRotation = Math.round(val * 100)
                            }
                            onValueChanged: {
                                MoveCenterTabController.tempRotation = Math.round(spaceRotationSlider.value * 100)
                                //spaceRotationText.text = Math.round(spaceRotationSlider.value) + "°"
                            }
                        }

                        MyPushButton2 {
                            id: spaceRotationPlusButton
                            Layout.preferredWidth: 40
                            text: "+"
                            onClicked: {
                                var val = ( MoveCenterTabController.tempRotation / 100 ) + 45
                                if (val > 180) {
                                    val = val -360;
                                }
                                MoveCenterTabController.tempRotation = val * 100
                            }
                        }

                        MyTextField {
                            id: spaceRotationText
                            text: "0°"
                            keyBoardUID: 104
                            Layout.preferredWidth: 150
                            Layout.leftMargin: 10
                            horizontalAlignment: Text.AlignHCenter
                            function onInputEvent(input) {
                                var val = parseFloat(input)
                                if (!isNaN(val)) {
                                    val = val % 180
                                    MoveCenterTabController.tempRotation = Math.round(val * 100)
                                    text = ( MoveCenterTabController.tempRotation / 100 ) + "°"
                                } else {
                                    text = ( MoveCenterTabController.tempRotation / 100 ) + "°"
                                }
                            }
                        }
                        MyPushButton {
                            id: spaceRotationApplyButton
                            Layout.preferredWidth: 145
                            text:"应用"
                            onClicked: {
                                MoveCenterTabController.rotation = MoveCenterTabController.tempRotation
                            }
                       }
                    }
                }
            }
        }


        ColumnLayout {
            RowLayout {
                Layout.fillWidth: true
                id: resetButtonRow
                visible: true

                MyPushButton {
                    id: spaceResetButton
                    Layout.preferredWidth: 250
                    text: "重置"
                    onClicked: {
                        MoveCenterTabController.reset()
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                MyPushButton {
                    id: spaceLogMatrices
                    Layout.preferredWidth: 250
                    visible: MoveCenterTabController.showLogMatricesButton
                    text: "打印矩阵日志"
                    onClicked: {
                        MoveCenterTabController.outputLogPoses()
                    }
                }

                MyPushButton {
                    id: spaceSeatedRecenter
                    Layout.preferredWidth: 250
                    visible: true
                    text: "重新居中"
                    onClicked: {
                        MoveCenterTabController.sendSeatedRecenter()
                    }
                }

            }
        }



        Item { Layout.fillHeight: true; Layout.fillWidth: true}

        Component.onCompleted: {
            spaceMoveXText.text = MoveCenterTabController.offsetX.toFixed(2)
            spaceMoveYText.text = MoveCenterTabController.offsetY.toFixed(2)
            spaceMoveZText.text = MoveCenterTabController.offsetZ.toFixed(2)
            spaceRotationSlider.value = MoveCenterTabController.rotation
			lockXToggle.checked = MoveCenterTabController.lockXToggle
			lockYToggle.checked = MoveCenterTabController.lockYToggle
			lockZToggle.checked = MoveCenterTabController.lockZToggle
            spaceLogMatrices.visible = MoveCenterTabController.showLogMatricesButton
			
            if (MoveCenterTabController.trackingUniverse === 0) {
                spaceModeText.text = "坐姿"
                spaceSeatedRecenter.visible = true
            } else if (MoveCenterTabController.trackingUniverse === 1) {
                spaceModeText.text = "站姿"
            } else {
                spaceModeText.text = "未知(" + MoveCenterTabController.trackingUniverse + ")"
            }
            reloadOffsetProfiles()
        }

        Connections {
            target: MoveCenterTabController
            onOffsetXChanged: {
                spaceMoveXText.text = MoveCenterTabController.offsetX.toFixed(2)
            }
            onOffsetYChanged: {
                spaceMoveYText.text = MoveCenterTabController.offsetY.toFixed(2)
            }
            onOffsetZChanged: {
                spaceMoveZText.text = MoveCenterTabController.offsetZ.toFixed(2)
            }
            onRotationChanged: {
                spaceRotationSlider.value = ( MoveCenterTabController.rotation / 100 )
            }
            onTempRotationChanged: {
                var intTempRotation = MoveCenterTabController.tempRotation
                spaceRotationSlider.value = ( intTempRotation / 100 )
                spaceRotationText.text = ( intTempRotation / 100 ) + "°"
            }
			onLockXToggleChanged: {
				lockXToggle.checked = MoveCenterTabController.lockXToggle
			}
			onLockYToggleChanged: {
				lockYToggle.checked = MoveCenterTabController.lockYToggle
			}
			onLockZToggleChanged: {
				lockZToggle.checked = MoveCenterTabController.lockZToggle
			}
            onTrackingUniverseChanged: {
                if (MoveCenterTabController.trackingUniverse === 0) {
                    spaceModeText.text = "坐姿"
                    spaceSeatedRecenter.visible = true
                } else if (MoveCenterTabController.trackingUniverse === 1) {
                    spaceModeText.text = "站姿"
                } else {
                    spaceModeText.text = "未知(" + MoveCenterTabController.trackingUniverse + ")"
                }
            }
            onOffsetProfilesUpdated: {
                reloadOffsetProfiles()
            }
        }

    }
    function reloadOffsetProfiles() {
        var profiles = [""]
        var profileCount = MoveCenterTabController.getOffsetProfileCount()
        for (var i = 0; i < profileCount; i++) {
            profiles.push(MoveCenterTabController.getOffsetProfileName(i))
        }
        offsetProfileComboBox.currentIndex = 0
        offsetProfileComboBox.model = profiles
    }
}
