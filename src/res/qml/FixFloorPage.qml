import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import ovras.advsettings 1.0
import "common"


MyStackViewPage {
    headerText: "空间修正"

    content: ColumnLayout {
        spacing: 18

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        MyText {
            text: "将一个控制器放在地面上，并确保在基站可见范围内。"
            wrapMode: Text.WordWrap
            font.pointSize: 28
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Layout.fillWidth: true
        }

        MyText {
            text: "（坐姿模式下不可用）"
            id: seatedWarningText
            visible: false
            wrapMode: Text.WordWrap
            font.pointSize: 28
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Layout.fillWidth: true
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        MyText {
            id: statusMessageText
            enabled: false
            text: "Status Text"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Layout.fillWidth: true
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        MyPushButton {
            id: fixButton
            Layout.fillWidth: true
            text: "修正地面"
            Layout.preferredHeight: 80
            onClicked: {
                FixFloorTabController.fixFloorClicked()
            }
        }

		MyPushButton {
            id: recenterButton
            Layout.fillWidth: true
            text: "重新居中"
            Layout.preferredHeight: 80
            onClicked: {
                FixFloorTabController.recenterClicked()
            }
        }

        MyPushButton {
            id: undoFixButton
            enabled: false
            // TODO re-enable undo and remove visible: false
            visible: false
            Layout.fillWidth: true
            text: "撤销修正"
            onClicked: {
                FixFloorTabController.undoFixFloorClicked()
            }
        }

        MyPushButton {
            id: zeroSpaceButton
            Layout.fillWidth: true
            text: "将空间偏移设为中心"
            Layout.preferredHeight: 80
            onClicked: {
                MoveCenterTabController.addCurOffsetAsCenter()
            }
        }

        Item {
            Layout.preferredHeight: 32
        }

        MyPushButton {
            id: revertButton
            Layout.fillWidth: true
            text: "恢复本次会话的所有更改"
            Layout.preferredHeight: 80
            onClicked: {
                ChaperoneTabController.applyAutosavedProfile()
            }
        }

        Item {
            Layout.preferredHeight: 32
        }

        Component.onCompleted: {
            statusMessageText.text = ""
            //undoFixButton.enabled = FixFloorTabController.canUndo
            fixButton.enabled = true

            if (MoveCenterTabController.trackingUniverse === 0) {
                fixButton.enabled = false
                recenterButton.enabled = false
                zeroSpaceButton.enabled = false
                revertButton.enabled = false
                undoFixButton.enabled = false
                seatedWarningText.visible = true
            }
        }

        Timer {
            id: statusMessageTimer
            repeat: false
            onTriggered: {
                statusMessageText.text = ""
            }
        }

        Connections {
            target: FixFloorTabController
            onStatusMessageSignal: {
                if (statusMessageTimer.running) {
                    statusMessageTimer.stop()
                }
                statusMessageText.text = FixFloorTabController.currentStatusMessage()
                statusMessageTimer.interval = FixFloorTabController.currentStatusMessageTimeout() * 1000
                statusMessageTimer.start()
            }
            onMeasureStartSignal: {
                fixButton.enabled = false
                undoFixButton.enabled = false
            }
            onMeasureEndSignal: {
                fixButton.enabled = true
                // undoFixButton.enabled = FixFloorTabController.canUndo
            }
            onCanUndoChanged: {
                //undoFixButton.enabled = FixFloorTabController.canUndo
                // revert below to this -^
                undoFixButton.enabled = false
            }
        }

        Connections {
            target: MoveCenterTabController
            onTrackingUniverseChanged: {
                if (MoveCenterTabController.trackingUniverse === 0) {
                    fixButton.enabled = false
                    recenterButton.enabled = false
                    zeroSpaceButton.enabled = false
                    revertButton.enabled = false
                    undoFixButton.enabled = false
                    seatedWarningText.visible = true
                } else if (MoveCenterTabController.trackingUniverse === 1) {
                    fixButton.enabled = true
                    recenterButton.enabled = true
                    zeroSpaceButton.enabled = true
                    revertButton.enabled = true
                    // undoFixButton.enabled = true
                    // TODO Fix Undo Feature -^
                    seatedWarningText.visible = false
                } else {
                    fixButton.enabled = false
                    recenterButton.enabled = false
                    zeroSpaceButton.enabled = false
                    revertButton.enabled = false
                    undoFixButton.enabled = false
                    seatedWarningText.visible = false
                }
            }
        }

    }

}
