import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import ovras.advsettings 1.0
import "common"


MyStackViewPage {
    headerText: qsTr("Statistics")

    content: ColumnLayout {
        spacing: 18

        GridLayout {
            columns: 3

            MyText {
                text: qsTr("HMD Distance Moved:")
            }

            MyText {
                id: statsHmdMovedText
                text: "-00.0"
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
                Layout.rightMargin: 10
            }

            MyPushButton {
                text: qsTr("Reset")
                onClicked: {
                    StatisticsTabController.statsDistanceResetClicked()
                }
            }

            MyText {
                text: qsTr("HMD Rotations:")
            }

            MyText {
                id: statsHmdRotationText
                text: qsTr("0.0 CCW")
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
                Layout.rightMargin: 10
            }

            MyPushButton {
                text: qsTr("Reset")
                onClicked: {
                    StatisticsTabController.statsRotationResetClicked()
                }
            }

            MyText {
                text: qsTr("Left Controller Max Speed:")
            }

            MyText {
                id: statsLeftControllerSpeedText
                text: qsTr("99.9 m/s")
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
                Layout.rightMargin: 10
            }

            MyPushButton {
                text: qsTr("Reset")
                onClicked: {
                    StatisticsTabController.statsLeftControllerSpeedResetClicked()
                }
            }

            MyText {
                text: qsTr("Right Controller Max Speed:")
            }

            MyText {
                id: statsRightControllerSpeedText
                text: qsTr("99.9 m/s")
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
                Layout.rightMargin: 10
            }

            MyPushButton {
                text: qsTr("Reset")
                onClicked: {
                    StatisticsTabController.statsRightControllerSpeedResetClicked()
                }
            }
        }

        GridLayout {
            columns: 3
            Layout.topMargin: 32

            MyText {
                text: qsTr("Presented Frames:")
            }

            MyText {
                id: statsPresentedFramesText
                text: "000"
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
                Layout.rightMargin: 10
            }

            MyPushButton {
                text: qsTr("Reset")
                onClicked: {
                    StatisticsTabController.presentedFramesResetClicked()
                }
            }

            MyText {
                text: qsTr("Dropped Frames:")
            }

            MyText {
                id: statsDroppedFramesText
                text: "000"
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
                Layout.rightMargin: 10
            }

            MyPushButton {
                text: qsTr("Reset")
                onClicked: {
                    StatisticsTabController.droppedFramesResetClicked()
                }
            }

            MyText {
                text: qsTr("Reprojected Frames:")
            }

            MyText {
                id: statsReprojectionFramesText
                text: "000"
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
                Layout.rightMargin: 10
            }

            MyPushButton {
                text: qsTr("Reset")
                onClicked: {
                    StatisticsTabController.reprojectedFramesResetClicked()
                }
            }

            MyText {
                text: qsTr("Timed Out:")
            }

            MyText {
                id: statsTimedOutText
                text: "000"
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
                Layout.rightMargin: 10
            }

            MyPushButton {
                text: qsTr("Reset")
                onClicked: {
                    StatisticsTabController.timedOutResetClicked()
                }
            }

            MyText {
                text: qsTr("Reprojection Ratio:")
            }

            MyText {
                id: statstotalRatioText
                text: "0.0"
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
                Layout.rightMargin: 10
            }

            MyPushButton {
                text: qsTr("Reset")
                onClicked: {
                    StatisticsTabController.totalRatioResetClicked()
                }
            }
        }
        Item {
            Layout.fillHeight: true
        }

        function updateStatistics() {
            statsHmdMovedText.text = StatisticsTabController.hmdDistanceMoved.toFixed(1) + " m"
            var rotations = StatisticsTabController.hmdRotations
            if (rotations > 0) {
                statsHmdRotationText.text = qsTr("%1 CCW").arg(rotations.toFixed(2))
            } else {
                statsHmdRotationText.text = qsTr("%1 CW").arg((-rotations).toFixed(2))
            }
            statsLeftControllerSpeedText.text = qsTr("%1 m/s").arg(StatisticsTabController.leftControllerMaxSpeed.toFixed(1))
            statsRightControllerSpeedText.text = qsTr("%1 m/s").arg(StatisticsTabController.rightControllerMaxSpeed.toFixed(1))
            statsPresentedFramesText.text = StatisticsTabController.presentedFrames
            statsDroppedFramesText.text = StatisticsTabController.droppedFrames
            statsReprojectionFramesText.text = StatisticsTabController.reprojectedFrames
            statsTimedOutText.text = StatisticsTabController.timedOut
            statstotalRatioText.text = (StatisticsTabController.totalReprojectedRatio*100.0).toFixed(1) + "%"
        }

        Timer {
            id: statisticsUpdateTimer
            repeat: true
            interval: 100
            onTriggered: {
                parent.updateStatistics()
            }
        }

        onVisibleChanged: {
            if (visible) {
                updateStatistics()
                statisticsUpdateTimer.start()
            } else {
                statisticsUpdateTimer.stop()
            }
        }

    }

}
