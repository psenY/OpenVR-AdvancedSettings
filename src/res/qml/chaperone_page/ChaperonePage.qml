import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import ovras.advsettings 1.0
import "." // QTBUG-34418, singletons require explicit import to load qmldir file
import "../common"
import "change_orientation"

MyStackViewPage {
    headerText: "边界设置"

    MyDialogOkPopup {
        id: chaperoneMessageDialog
        function showMessage(title, text) {
            dialogTitle = title
            dialogText = text
            open()
        }
    }

    MyDialogOkCancelPopup {
        id: chaperoneDeleteProfileDialog
        property int profileIndex: -1
        dialogTitle: "删除配置文件"
        dialogText: "您确定要删除此配置文件吗？"
        onClosed: {
            if (okClicked) {
                ChaperoneTabController.deleteChaperoneProfile(profileIndex)
            }
        }
    }

    MyDialogOkCancelPopup {
        id: chaperoneNewProfileDialog
        dialogTitle: "新建配置文件"
        dialogWidth: 800
        dialogHeight: 780
        dialogContentItem: ColumnLayout {
            RowLayout {
                Layout.topMargin: 16
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                MyText {
                    text: "名称: "
                }
                MyTextField {
                    id: chaperoneNewProfileName
                    keyBoardUID: 390
                    color: "#d9dbe0"
                    text: ""
                    Layout.fillWidth: true
                    font.pointSize: 20
                    function onInputEvent(input) {
                        chaperoneNewProfileName.text = input
                    }
                }
            }
            MyText {
                Layout.topMargin: 24
                text: "包含内容:"
            }
            MyToggleButton {
                id: chaperoneNewProfileIncludeGeometry
                Layout.leftMargin: 32
                text: "边界几何形状"
            }
            MyToggleButton {
                id: chaperoneNewProfileIncludeStyle
                Layout.leftMargin: 32
                text: "边界样式"
            }
            MyToggleButton {
                id: chaperoneNewProfileIncludeBoundsColor
                Layout.leftMargin: 32
                text: "边界颜色"
            }
            MyToggleButton {
                id: chaperoneNewProfileIncludeVisibility
                Layout.leftMargin: 32
                text: "可见性设置"
            }
            MyToggleButton {
                id: chaperoneNewProfileIncludeFadeDistance
                Layout.leftMargin: 32
                text: "渐隐距离设置"
            }
            MyToggleButton {
                id: chaperoneNewProfileIncludeCenterMarker
                Layout.leftMargin: 32
                text: "中心标记设置"
            }
            MyToggleButton {
                id: chaperoneNewProfileIncludePlaySpaceMarker
                Layout.leftMargin: 32
                text: "游戏空间标记设置"
            }
            MyToggleButton {
                id: chaperoneNewProfileIncludeFloorBoundsMarker
                Layout.leftMargin: 32
                text: "始终显示地面边界设置"
            }
            MyToggleButton {
                id: chaperoneNewProfileIncludeForceBounds
                Layout.leftMargin: 32
                text: "强制边界设置"
            }
            MyToggleButton {
                id: chaperoneNewProfileIncludeProximityWarnings
                Layout.leftMargin: 32
                text: "接近警告设置"
            }
        }
        onClosed: {
            if (okClicked) {
                if (chaperoneNewProfileName.text == "") {
                    chaperoneMessageDialog.showMessage("Create New Profile", "ERROR: Empty profile name.")
                } else if (!chaperoneNewProfileIncludeGeometry.checked
                            && !chaperoneNewProfileIncludeVisibility.checked
                            && !chaperoneNewProfileIncludeFadeDistance.checked
                            && !chaperoneNewProfileIncludeCenterMarker.checked
                            && !chaperoneNewProfileIncludePlaySpaceMarker.checked
                            && !chaperoneNewProfileIncludeFloorBoundsMarker.checked
                            && !chaperoneNewProfileIncludeBoundsColor.checked
                            && !chaperoneNewProfileIncludeStyle.checked
                            && !chaperoneNewProfileIncludeForceBounds.checked
                            && !chaperoneNewProfileIncludeProximityWarnings.checked) {
                    chaperoneMessageDialog.showMessage("Create New Profile", "ERROR: Nothing included.")
                } else if ( Math.abs(MoveCenterTabController.offsetX) > 0.00000000001
                           || Math.abs(MoveCenterTabController.offsetY) > 0.00000000001
                           || Math.abs(MoveCenterTabController.offsetZ) > 0.00000000001
                           || MoveCenterTabController.rotation !== 0) {
                    chaperoneMessageDialog.showMessage("Create New Profile", "ERROR: Offsets not reset.")
                } else {
                    ChaperoneTabController.addChaperoneProfile(chaperoneNewProfileName.text,
                                                               chaperoneNewProfileIncludeGeometry.checked,
                                                               chaperoneNewProfileIncludeVisibility.checked,
                                                               chaperoneNewProfileIncludeFadeDistance.checked,
                                                               chaperoneNewProfileIncludeCenterMarker.checked,
                                                               chaperoneNewProfileIncludePlaySpaceMarker.checked,
                                                               chaperoneNewProfileIncludeFloorBoundsMarker.checked,
                                                               chaperoneNewProfileIncludeBoundsColor.checked,
                                                               chaperoneNewProfileIncludeStyle.checked,
                                                               chaperoneNewProfileIncludeForceBounds.checked,
                                                               chaperoneNewProfileIncludeProximityWarnings.checked)
                }

            }
        }
        function openPopup() {
            chaperoneNewProfileName.text = ""
            chaperoneNewProfileIncludeGeometry.checked = false
            chaperoneNewProfileIncludeVisibility.checked = false
            chaperoneNewProfileIncludeFadeDistance.checked = false
            chaperoneNewProfileIncludeCenterMarker.checked = false
            chaperoneNewProfileIncludePlaySpaceMarker.checked = false
            chaperoneNewProfileIncludeFloorBoundsMarker.checked = false
            chaperoneNewProfileIncludeBoundsColor.checked = false
            chaperoneNewProfileIncludeStyle.checked = false
            chaperoneNewProfileIncludeForceBounds.checked = false
            chaperoneNewProfileIncludeProximityWarnings.checked = false
            open()
        }
    }


    content: ColumnLayout {
        spacing: 18

        ColumnLayout {
            Layout.bottomMargin: 32
            spacing: 18
            RowLayout {
                spacing: 18

                MyText {
                    text: "配置文件:"
                }

                MyComboBox {
                    id: chaperoneProfileComboBox
                    Layout.maximumWidth: 799
                    Layout.minimumWidth: 799
                    Layout.preferredWidth: 799
                    Layout.fillWidth: true
                    model: [""]
                    onCurrentIndexChanged: {
                        if (currentIndex > 0) {
                            chaperoneApplyProfileButton.enabled = true
                            chaperoneDeleteProfileButton.enabled = true
                        } else {
                            chaperoneApplyProfileButton.enabled = false
                            chaperoneDeleteProfileButton.enabled = false
                        }
                    }
                }

                MyPushButton {
                    id: chaperoneApplyProfileButton
                    enabled: false
                    Layout.preferredWidth: 200
                    text: "应用"
                    onClicked: {
                        if (chaperoneProfileComboBox.currentIndex > 0) {
                            ChaperoneTabController.applyChaperoneProfile(chaperoneProfileComboBox.currentIndex - 1)
                            chaperoneProfileComboBox.currentIndex = 0
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
                    id: chaperoneDeleteProfileButton
                    enabled: false
                    Layout.preferredWidth: 200
                    text: "删除配置文件"
                    onClicked: {
                        if (chaperoneProfileComboBox.currentIndex > 0) {
                            chaperoneDeleteProfileDialog.profileIndex = chaperoneProfileComboBox.currentIndex - 1
                            chaperoneDeleteProfileDialog.open()
                        }
                    }
                }
                MyPushButton {
                    Layout.preferredWidth: 200
                    text: "新建配置文件"
                    onClicked: {
                        chaperoneNewProfileDialog.openPopup()
                    }
                }
            }
        }

        GridLayout {
            columns: 5

            MyText {
                text: "可见性:"
                Layout.rightMargin: 12
            }

            MyPushButton2 {
                id: chaperoneVisibilityMinus
                text: "-"
                Layout.preferredWidth: 40
                onClicked: {
                    chaperoneVisibilitySlider.value -= 0.05
                }
            }

            MySlider {
                id: chaperoneVisibilitySlider
                from: 0.3
                to: 1.0
                stepSize: 0.01
                value: 0.6
                Layout.fillWidth: true
                onPositionChanged: {
                    var val = (this.value * 100)
                    chaperoneVisibilityText.text = Math.round(val) + "%"
                }
                onValueChanged: {
                    ChaperoneTabController.setBoundsVisibility(value.toFixed(2), false)
                }
            }

            MyPushButton2 {
                id: chaperoneVisibilityPlus
                text: "+"
                Layout.preferredWidth: 40
                onClicked: {
                    chaperoneVisibilitySlider.value += 0.05
                }
            }


            MyTextField {
                id: chaperoneVisibilityText
                text: "60.00"
                keyBoardUID: 301
                Layout.preferredWidth: 100
                Layout.leftMargin: 10
                horizontalAlignment: Text.AlignHCenter
                function onInputEvent(input) {
                    var val = parseFloat(input)
                    if (!isNaN(val)) {
                        if (val < 30.0) {
                            val = 30.0
                        } else if (val > 100.0) {
                            val = 100.0
                        }
                        if(val>100){
                            val = 100.0
                        }

                        var v = (val/100).toFixed(2)
                        if (v <= chaperoneVisibilitySlider.to) {
                            chaperoneVisibilitySlider.value = v
                        } else {
                            ChaperoneTabController.setBoundsVisibility(v, false)
                        }
                    }
                    text = Math.round(ChaperoneTabController.boundsVisibility * 100) + "%"
                }
            }

            MyText {
                text: "渐隐距离:"
                Layout.rightMargin: 12
            }

            MyPushButton2 {
                id: chaperoneFadeDistanceMinus
                text: "-"
                Layout.preferredWidth: 40
                onClicked: {
                    chaperoneFadeDistanceSlider.decrease()
                }
            }

            MySlider {
                id: chaperoneFadeDistanceSlider
                from: 0.0
                to: 2.0
                stepSize: 0.1
                value: 0.7
                Layout.fillWidth: true
                onPositionChanged: {
                    var val = this.from + ( this.position  * (this.to - this.from))
                    chaperoneFadeDistanceText.text = val.toFixed(1)
                }
                onValueChanged: {
                    ChaperoneTabController.setFadeDistance(this.value.toFixed(1), false)
                }
            }

            MyPushButton2 {
                id: chaperoneFadeDistancePlus
                text: "+"
                Layout.preferredWidth: 40
                onClicked: {
                    chaperoneFadeDistanceSlider.increase()
                }
            }

            MyTextField {
                id: chaperoneFadeDistanceText
                text: "0.00"
                keyBoardUID: 302
                Layout.preferredWidth: 100
                Layout.leftMargin: 10
                horizontalAlignment: Text.AlignHCenter
                function onInputEvent(input) {
                    var val = parseFloat(input)
                    if (!isNaN(val)) {
                        if (val < 0.0) {
                            val = 0.0
                        }
                        var v = val.toFixed(1)
                        if (v <= chaperoneFadeDistanceSlider.to) {
                            chaperoneFadeDistanceSlider.value = v
                        } else {
                            ChaperoneTabController.setFadeDistance(v, false)
                        }
                    }
                    text = ChaperoneTabController.fadeDistance.toFixed(1)
                }
            }

            MyText {
                text: "高度:"
                Layout.rightMargin: 12
            }

            MyPushButton2 {
                text: "-"
                Layout.preferredWidth: 40
                onClicked: {
                    chaperoneHeightSlider.decrease()
                }
            }

            MySlider {
                id: chaperoneHeightSlider
                from: 0.01
                to: 5.0
                stepSize: 0.01
                value: 2.0
                Layout.fillWidth: true
                onPositionChanged: {
                    var val = (this.from + ( this.position  * (this.to - this.from))).toFixed(2)
                    if (activeFocus) {
                        ChaperoneTabController.setHeight(val, false);
                    }
                    chaperoneHeightText.text = val
                }
                onValueChanged: {
                    ChaperoneTabController.setHeight(value.toFixed(2), false)
                }
            }

            MyPushButton2 {
                text: "+"
                Layout.preferredWidth: 40
                onClicked: {
                    chaperoneHeightSlider.increase()
                }
            }

            MyTextField {
                id: chaperoneHeightText
                text: "0.00"
                keyBoardUID: 303
                Layout.preferredWidth: 100
                Layout.leftMargin: 10
                horizontalAlignment: Text.AlignHCenter
                function onInputEvent(input) {
                    var val = parseFloat(input)
                    if (!isNaN(val)) {
                        if (val < 0.01) {
                            val = 0.01
                        }
                        var v = val.toFixed(2)
                        if (v <= chaperoneHeightSlider.to) {
                            chaperoneHeightSlider.value = v
                        } else {
                            ChaperoneTabController.setHeight(v, false)
                        }
                    }
                    text = ChaperoneTabController.height.toFixed(2)
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 32

            MyToggleButton {
                id: chaperoneCenterMarkerToggle
                text: "中心标记"
                Layout.fillWidth: false
                onCheckedChanged: {
                    ChaperoneTabController.setCenterMarkerNew(this.checked, false)
                }
            }

            MyToggleButton {
                id: chaperonePlaySpaceToggle
                text: "游戏空间"
                onCheckedChanged: {
                    ChaperoneTabController.setPlaySpaceMarker(this.checked, false)
                }
            }

            MyToggleButton {
                id: chaperoneForceBoundsToggle
                text: "强制边界"
                onCheckedChanged: {
                    ChaperoneTabController.setForceBounds(this.checked, false)
                }
            }
            MyToggleButton {
                id: chaperoneDisableChaperone
                text: "禁用边界"
                onCheckedChanged: {
                    ChaperoneTabController.setDisableChaperone(this.checked, false)
                    if(this.checked){
                        chaperoneFadeDistanceMinus.enabled = false;
                        chaperoneFadeDistancePlus.enabled = false;
                        chaperoneFadeDistanceSlider.enabled = false;
                        chaperoneFadeDistanceText.enabled = false;

                    }else{
                        chaperoneFadeDistanceMinus.enabled = true;
                        chaperoneFadeDistancePlus.enabled = true;
                        chaperoneFadeDistanceSlider.enabled = true;
                        chaperoneFadeDistanceText.enabled = true;
                    }
                }
            }

            Item { Layout.fillWidth: true }
        }

        RowLayout {
            Layout.fillWidth: true
            MyPushButton {
                id: chaperoneWarningsConfigButton
                text: "接近警告设置"
                Layout.preferredWidth: 350
                onClicked: {
                    MyResources.playFocusChangedSound()
                    mainView.push(chaperoneWarningsPage)
                }
            }
            Item {Layout.fillWidth: true}

            MyPushButton {
                id: chaperoneAdditionalButton
                text: "其他边界设置"
                Layout.preferredWidth: 400

                onClicked: {
                    MyResources.playFocusChangedSound()
                    mainView.push(chaperoneAdditionalPage)
                }
            }
        }

        ChangeOrientationGroupBox { }


        Item { Layout.fillHeight: true; Layout.fillWidth: true}

        RowLayout {
            Layout.fillWidth: true

            MyPushButton {
                id: chaperoneResetButton
                text: "重置"
                Layout.preferredWidth: 250
                onClicked: {
                    ChaperoneTabController.reset()
                }
            }

            Item { Layout.fillWidth: true}

            MyPushButton {
                id: chaperoneReloadFromDiskButton
                text: "从磁盘重新加载"
                Layout.preferredWidth: 250
                onClicked: {
                    ChaperoneTabController.reloadFromDisk()
                }
            }
        }

        Component.onCompleted: {
            chaperoneVisibilitySlider.value = ChaperoneTabController.boundsVisibility
            if(chaperoneVisibilitySlider.value < 0.3){
                chaperoneVisibilitySlider.value = 0.3
            }

            var d = ChaperoneTabController.fadeDistance.toFixed(1)
            if (d <= chaperoneFadeDistanceSlider.to) {
                chaperoneFadeDistanceSlider.value = d
            }
            chaperoneFadeDistanceText.text = d
            var h = ChaperoneTabController.height.toFixed(2)
            if (h <= chaperoneHeightSlider.to) {
                chaperoneHeightSlider.value = h
            }
            chaperoneHeightText.text = h
            chaperoneCenterMarkerToggle.checked = ChaperoneTabController.centerMarkerNew
            //We Need a Set call on init in order to display the overlay!
            ChaperoneTabController.setCenterMarkerNew(chaperoneCenterMarkerToggle.checked);
            chaperonePlaySpaceToggle.checked = ChaperoneTabController.playSpaceMarker
            chaperoneForceBoundsToggle.checked = ChaperoneTabController.forceBounds
            chaperoneDisableChaperone.checked = ChaperoneTabController.disableChaperone
            var dim = ChaperoneTabController.chaperoneDimHeight
            if(dim > 0.0){
                chaperoneDisableChaperone.enabled = false;
            }else{
                chaperoneDisableChaperone.enabled = true;
            }
            if(dim > 0.0 || chaperoneDisableChaperone.checked){
                chaperoneFadeDistanceMinus.enabled = false;
                chaperoneFadeDistancePlus.enabled = false;
                chaperoneFadeDistanceSlider.enabled = false;
                chaperoneFadeDistanceText.enabled = false;

            }else{
                chaperoneFadeDistanceMinus.enabled = true;
                chaperoneFadeDistancePlus.enabled = true;
                chaperoneFadeDistanceSlider.enabled = true;
                chaperoneFadeDistanceText.enabled = true;
            }
            reloadChaperoneProfiles()
        }

        Connections {
            target: ChaperoneTabController
            onBoundsVisibilityChanged: {
                if (Math.abs(chaperoneVisibilitySlider.value - ChaperoneTabController.boundsVisibility) > 0.008) {
                    chaperoneVisibilitySlider.value = ChaperoneTabController.boundsVisibility
                }
            }
            onFadeDistanceChanged: {
                var d = ChaperoneTabController.fadeDistance.toFixed(1)
                if (d <= chaperoneFadeDistanceSlider.to && Math.abs(chaperoneFadeDistanceSlider.value - d) > 0.008) {
                    chaperoneFadeDistanceSlider.value = d
                }
                chaperoneFadeDistanceText.text = d
            }
            onHeightChanged: {
                var h = ChaperoneTabController.height.toFixed(2)
                if (h <= chaperoneHeightSlider.to && Math.abs(chaperoneHeightSlider.value - h) > 0.008) {
                    chaperoneHeightSlider.value = h
                }
                chaperoneHeightText.text = h
            }
            onChaperoneDimHeightChanged: {
                var dim = ChaperoneTabController.chaperoneDimHeight
                if(dim > 0.0){
                    chaperoneDisableChaperone.enabled = false;
                }else{
                    chaperoneDisableChaperone.enabled = true;
                }
                if(dim > 0.0 || chaperoneDisableChaperone.checked){
                    chaperoneFadeDistanceMinus.enabled = false;
                    chaperoneFadeDistancePlus.enabled = false;
                    chaperoneFadeDistanceSlider.enabled = false;
                    chaperoneFadeDistanceText.enabled = false;

                }else{
                    chaperoneFadeDistanceMinus.enabled = true;
                    chaperoneFadeDistancePlus.enabled = true;
                    chaperoneFadeDistanceSlider.enabled = true;
                    chaperoneFadeDistanceText.enabled = true;
                }
            }
            onCenterMarkerNewChanged: {
                chaperoneCenterMarkerToggle.checked = ChaperoneTabController.centerMarkerNew
            }
            onPlaySpaceMarkerChanged: {
                chaperonePlaySpaceToggle.checked = ChaperoneTabController.playSpaceMarker
            }
            onForceBoundsChanged: {
                chaperoneForceBoundsToggle.checked = ChaperoneTabController.forceBounds
            }
            onChaperoneProfilesUpdated: {
                reloadChaperoneProfiles()
            }
        }
    }

    function reloadChaperoneProfiles() {
        var profiles = [""]
        var profileCount = ChaperoneTabController.getChaperoneProfileCount()
        for (var i = 0; i < profileCount; i++) {
            profiles.push(ChaperoneTabController.getChaperoneProfileName(i))
        }
        chaperoneProfileComboBox.currentIndex = 0
        chaperoneProfileComboBox.model = profiles
    }
}
