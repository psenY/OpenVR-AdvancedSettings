import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import ovras.advsettings 1.0
import "." // QTBUG-34418, singletons require explicit import to load qmldir file
import "common"
import "utilities_page"
import "audio_page"
import "video_page"

MyStackViewPage {
    id: rootPage
    width: 1200
    height: 800
    headerText: qsTr("OVR Advanced Settings")
    headerShowBackButton: false
    stackView: mainView
    content: Item {
           ColumnLayout {
           anchors.fill: parent
           RowLayout {
               Layout.fillHeight: true
               Layout.fillWidth: true
               ColumnLayout {
                   Layout.preferredWidth: 250
                   Layout.maximumWidth: 250
                   Layout.fillHeight: true
                   spacing: 10
                   MyPushButton {
                       id: steamVRButton
                       iconPath: "qrc:/main_menu_icons/steamvr_tab_icon"
                       activationSoundEnabled: false
                       text: qsTr("   SteamVR")
                       Layout.fillWidth: true
                       onClicked: {
                           MyResources.playFocusChangedSound()
                           mainView.push(steamVRPage)
                       }
                   }

                   MyPushButton {
                       id: chaperoneButton
                       iconPath: "qrc:/main_menu_icons/chaperone_tab_icon"
                       activationSoundEnabled: false
                       text: qsTr("   Chaperone")
                       Layout.fillWidth: true
                       onClicked: {
                           MyResources.playFocusChangedSound()
                           mainView.push(chaperonePage)
                       }
                   }

                   MyPushButton {
                       id: playSpaceButton
                       iconPath: "qrc:/main_menu_icons/offsets_tab_icon"
                       activationSoundEnabled: false
                       text: qsTr("   Offsets")
                       Layout.fillWidth: true
                       onClicked: {
                           MyResources.playFocusChangedSound()
                           mainView.push(playspacePage)
                       }
                   }

                   MyPushButton {
                       id: motionButton
                       iconPath: "qrc:/main_menu_icons/motion_tab_icon"
                       activationSoundEnabled: false
                       text: qsTr("   Motion")
                       Layout.fillWidth: true
                       onClicked: {
                           MyResources.playFocusChangedSound()
                           mainView.push(motionPage)
                       }
                   }
                   MyPushButton {
                       id: rotationButton
                       iconPath: "qrc:/main_menu_icons/rotation_tab_icon"
                       activationSoundEnabled: false
                       text: qsTr("   Rotation")
                       Layout.fillWidth: true
                       onClicked: {
                           MyResources.playFocusChangedSound()
                           mainView.push(rotationPage)
                       }
                   }

                   MyPushButton {
                       id: fixFloorButton
                       iconPath: "qrc:/main_menu_icons/space_fix_tab_icon"
                       activationSoundEnabled: false
                       text: qsTr("   Space Fix")
                       Layout.fillWidth: true
                       onClicked: {
                           MyResources.playFocusChangedSound()
                           mainView.push(fixFloorPage)
                       }
                   }

                   MyPushButton {
                       id: audioButton
                       iconPath: "qrc:/main_menu_icons/audio_tab_icon"
                       activationSoundEnabled: false
                       text: qsTr("   Audio")
                       Layout.fillWidth: true
                       onClicked: {
                           MyResources.playFocusChangedSound()
                           mainView.push(audioPage)
                       }
                   }

                   MyPushButton {
                       id: videoButton
                       iconPath: "qrc:/main_menu_icons/video_tab_icon"
                       activationSoundEnabled: false
                       text: qsTr("   Video")
                       Layout.fillWidth: true
                       onClicked: {
                           MyResources.playFocusChangedSound()
                           mainView.push(videoPage)
                       }
                   }

                   MyPushButton {
                       id: utilitiesButton
                       iconPath: "qrc:/main_menu_icons/utilities_tab_icon"
                       activationSoundEnabled: false
                       text: qsTr("   Utilities")
                       Layout.fillWidth: true
                       onClicked: {
                           MyResources.playFocusChangedSound()
                           mainView.push(utilitiesPage)
                       }
                   }


                   MyPushButton {
                       id: statisticsButton
                       iconPath: "qrc:/main_menu_icons/statistics_tab_icon"
                       activationSoundEnabled: false
                       text: qsTr("   Statistics")
                       Layout.fillWidth: true
                       onClicked: {
                           MyResources.playFocusChangedSound()
                           mainView.push(statisticsPage)
                       }
                   }

                   Item {
                       Layout.fillHeight: true
                       Layout.fillWidth: true
                   }

                   MyPushButton {
                       id: bindingsButton
                       iconPath: "qrc:/main_menu_icons/bindings_tab_icon"
                       activationSoundEnabled: false
                       text: qsTr("   Bindings")
                       Layout.fillWidth: true
                       onClicked: {
                            SteamVRTabController.launchBindingUI()
                       }
                   }

                   MyPushButton {
                       id: settingsButton
                       iconPath: "qrc:/main_menu_icons/settings_tab_icon"
                       activationSoundEnabled: false
                       text: qsTr("   Settings")
                       Layout.fillWidth: true
                       onClicked: {
                           MyResources.playFocusChangedSound()
                           mainView.push(settingsPage)
                       }
                   }
               }


               ColumnLayout {
                   Layout.fillHeight: true
                   Layout.fillWidth: true
                   Layout.leftMargin: 80
                   spacing: 9

                   RowLayout {
                       spacing: 18

                       MyText {
                           text: qsTr("Video Profile:")
                       }
                       Item{
                          Layout.fillWidth: true
                       }

                       MyComboBox {
                           id: summaryVideoProfileComboBox
                           Layout.maximumWidth: 378
                           Layout.minimumWidth: 378
                           Layout.preferredWidth: 378
                           model: [""]
                           onCurrentIndexChanged: {
                               if (currentIndex > 0) {
                                   summaryVideoProfileApplyButton.enabled = true
                               } else {
                                   summaryVideoProfileApplyButton.enabled = false
                               }
                           }
                       }

                       MyPushButton {
                           id: summaryVideoProfileApplyButton
                           enabled: false
                           Layout.preferredWidth: 150
                           text: qsTr("Apply")
                           onClicked: {
                               if (summaryVideoProfileComboBox.currentIndex > 0) {
                                   VideoTabController.applyVideoProfile(summaryVideoProfileComboBox.currentIndex - 1)
                                   summaryVideoProfileComboBox.currentIndex = 0
                               }
                           }
                       }
                   }

                   RowLayout {
                       spacing: 18

                       MyText {
                           text: qsTr("Chaperone Profile:")
                       }

                       MyComboBox {
                           id: summaryChaperoneProfileComboBox
                           Layout.leftMargin: 47
                           Layout.maximumWidth: 378
                           Layout.minimumWidth: 378
                           Layout.preferredWidth: 378
                           Layout.fillWidth: true
                           model: [""]
                           onCurrentIndexChanged: {
                               if (currentIndex > 0) {
                                   summaryChaperoneProfileApplyButton.enabled = true
                               } else {
                                   summaryChaperoneProfileApplyButton.enabled = false
                               }
                           }
                       }

                       MyPushButton {
                           id: summaryChaperoneProfileApplyButton
                           enabled: false
                           Layout.preferredWidth: 150
                           text: qsTr("Apply")
                           onClicked: {
                               if (summaryChaperoneProfileComboBox.currentIndex > 0) {
                                   ChaperoneTabController.applyChaperoneProfile(summaryChaperoneProfileComboBox.currentIndex - 1)
                                   summaryChaperoneProfileComboBox.currentIndex = 0
                               }
                           }
                       }
                   }

                   Item {
                       Layout.fillHeight: true
                       Layout.fillWidth: true
                   }

                   RowLayout {
                       MyText {
                           text: qsTr("Tracking Universe:")
                       }
                       MyText {
                           id: summaryPlaySpaceModeText
                           Layout.fillWidth: true
                           horizontalAlignment: Text.AlignRight
                           text: qsTr("Unknown")
                       }
                   }

                   RowLayout {
                       MyText {
                           text: qsTr("HMD Rotations:")
                       }
                       MyText {
                           id: summaryHmdRotationsText
                           Layout.fillWidth: true
                           horizontalAlignment: Text.AlignRight
                           text: "-999.9"
                       }
                   }

                   Item {
                       Layout.fillHeight: true
                       Layout.fillWidth: true
                   }

                   RowLayout {
                       MyText {
                           text: qsTr("Dropped Frames:")
                       }
                       MyText {
                           id: summaryDroppedFramesText
                           Layout.fillWidth: true
                           horizontalAlignment: Text.AlignRight
                           text: "0"
                       }
                   }

                   RowLayout {
                       MyText {
                           text: qsTr("Reprojected Frames:")
                       }
                       MyText {
                           id: summaryReprojectedFramesText
                           Layout.fillWidth: true
                           horizontalAlignment: Text.AlignRight
                           text: "0"
                       }
                   }

                   RowLayout {
                       MyText {
                           text: qsTr("Timed Out:")
                       }
                       MyText {
                           id: summaryTimedOutText
                           Layout.fillWidth: true
                           horizontalAlignment: Text.AlignRight
                           text: "0"
                       }
                   }

                   RowLayout {
                       MyText {
                           text: qsTr("Reprojection Ratio:")
                       }
                       MyText {
                           id: summaryTotalRatioText
                           Layout.fillWidth: true
                           horizontalAlignment: Text.AlignRight
                           text: "0"
                       }
                   }

                   Item {
                       Layout.fillHeight: true
                       Layout.fillWidth: true
                   }



                   RowLayout {
                       MyText {
                           text: qsTr("Microphone:")
                       }
                       MySlider {
                           id: summaryMicVolumeSlider
                           from: 0.0
                           to: 1.0
                           stepSize: 0.01
                           value: 1.0
                           Layout.fillWidth: true
                           onPositionChanged: {
                               var val = this.position * 100
                               summaryMicVolumeText.text = Math.round(val) + "%"
                           }
                           onValueChanged: {
                               AudioTabController.setMicVolume(this.value.toFixed(2))
                           }
                       }
                       MyText {
                           id: summaryMicVolumeText
                           text: "100%"
                           Layout.preferredWidth: 85
                           horizontalAlignment: Text.AlignRight
                       }

                       MyPushButton2 {
                           id: summaryMicMuteToggle
                           Layout.leftMargin: 12
                           checkable: true
                           contentItem: Image {
                               source: parent.checked ? "qrc:/microphone/off" : "qrc:/microphone/on"
                               sourceSize.width: 32
                               sourceSize.height: 32
                               anchors.fill: parent
                           }
                           onCheckedChanged: {
                               AudioTabController.setMicMuted(checked)
                           }
                       }
                   }
                   RowLayout {
                       MyToggleButton {
                           id: summaryPttToggle
                           text: qsTr("Push-to-Talk")
                           onClicked: {
                                AudioTabController.setPttEnabled(checked, true)
                           }
                       }
                   }

                   Item {
                       Layout.fillHeight: true
                       Layout.fillWidth: true
                   }

                   RowLayout {

                           Rectangle {
                               id: summaryVersionCheckTextRect
                               visible: true
                               color: "#2a2e35"
                               MyText {
                                   id: summaryVersionCheckText
                                   text: ""
                                   color: "#3d4450"
                                   font.pointSize: 22
                                   minimumPointSize: 11
                                   fontSizeMode: Text.Fit
                                   leftPadding: 8
                                   rightPadding: 8
                                   horizontalAlignment: Text.AlignHCenter
                                   width: parent.width
                                   wrapMode: Text.Wrap
                               }
                               height: 40
                               Layout.fillWidth: true
                           }

                       MyText {
                           id: summaryVersionText
                           text: qsTr("v0.0.0")
                           font.pointSize: 16
                           horizontalAlignment: Text.AlignRight
                       }
                   }


               }
           }
       }
   }

   Component.onCompleted: {
       reloadChaperoneProfiles()
       reloadVideoProfiles()

       summaryVersionText.text = applicationVersion
       summaryVersionCheckText.text = OverlayController.versionCheckText
       if (OverlayController.newVersionDetected)
       {
           summaryVersionCheckTextRect.color = "#ff0000"
       } else {
           summaryVersionCheckTextRect.color = "#2a2e35"
       }


       if (MoveCenterTabController.trackingUniverse === 0) {
           summaryPlaySpaceModeText.text = qsTr("Sitting")
       } else if (MoveCenterTabController.trackingUniverse === 1) {
           summaryPlaySpaceModeText.text = qsTr("Standing")
       } else {
           summaryPlaySpaceModeText.text = qsTr("Unknown (%1)").arg(MoveCenterTabController.trackingUniverse)
       }
       updateStatistics()
       if (visible) {
           summaryUpdateTimer.start()
       }
       summaryMicVolumeSlider.value = AudioTabController.micVolume
       summaryMicMuteToggle.checked = AudioTabController.micMuted
       summaryPttToggle.checked = AudioTabController.pttEnabled
   }

   Connections {
       target: OverlayController
       onNewVersionDetectedChanged: {
           if (OverlayController.newVersionDetected)
           {
               summaryVersionCheckTextRect.color = "#ff0000"
           } else {
               summaryVersionCheckTextRect.color = "#2a2e35"
           }
       }
       onVersionCheckTextChanged: {
           summaryVersionCheckText.text = OverlayController.versionCheckText
       }
       onDisableVersionCheckChanged: {
           if (OverlayController.disableVersionCheck)
           {
               summaryVersionCheckText.visible = false
               summaryVersionCheckTextRect.color = "#2a2e35"
           } else {
               summaryVersionCheckText.visible = true
               if (OverlayController.newVersionDetected)
               {
                   summaryVersionCheckTextRect.color = "#ff0000"
               } else {
                   summaryVersionCheckTextRect.color = "#2a2e35"
               }
           }
       }
   }

   Connections {
       target: ChaperoneTabController
       onChaperoneProfilesUpdated: {
           reloadChaperoneProfiles()
       }
   }

   Connections {
       target: VideoTabController
       onVideoProfilesUpdated: {
           reloadVideoProfiles()
       }
   }

   Connections {
       target: AudioTabController
       onMicVolumeChanged: {
           summaryMicVolumeSlider.value = AudioTabController.micVolume
       }
       onMicMutedChanged: {
           summaryMicMuteToggle.checked = AudioTabController.micMuted
       }
       onPttEnabledChanged: {
           summaryPttToggle.checked = AudioTabController.pttEnabled
       }
   }

   Connections {
       target: MoveCenterTabController
       onTrackingUniverseChanged: {
           if (MoveCenterTabController.trackingUniverse === 0) {
               summaryPlaySpaceModeText.text = qsTr("Sitting")
           } else if (MoveCenterTabController.trackingUniverse === 1) {
               summaryPlaySpaceModeText.text = qsTr("Standing")
           } else {
               summaryPlaySpaceModeText.text = qsTr("Unknown (%1)").arg(MoveCenterTabController.trackingUniverse)
           }
       }
   }


   function updateStatistics() {
       var rotations = StatisticsTabController.hmdRotations
       if (rotations > 0) {
           summaryHmdRotationsText.text = qsTr("%1 CCW").arg(rotations.toFixed(2))
       } else {
           summaryHmdRotationsText.text = qsTr("%1 CW").arg((-rotations).toFixed(2))
       }
       summaryDroppedFramesText.text = StatisticsTabController.droppedFrames
       summaryReprojectedFramesText.text = StatisticsTabController.reprojectedFrames
       summaryTimedOutText.text = StatisticsTabController.timedOut
       summaryTotalRatioText.text = (StatisticsTabController.totalReprojectedRatio*100.0).toFixed(1) + "%"
   }

   Timer {
       id: summaryUpdateTimer
       repeat: true
       interval: 100
       onTriggered: {
           parent.updateStatistics()
       }
   }

   onVisibleChanged: {
       if (visible) {
           updateStatistics()
           summaryUpdateTimer.start()
       } else {
           summaryUpdateTimer.stop()
       }
   }


    function reloadChaperoneProfiles() {
       var profiles = [""]
       var profileCount = ChaperoneTabController.getChaperoneProfileCount()
       for (var i = 0; i < profileCount; i++) {
           profiles.push(ChaperoneTabController.getChaperoneProfileName(i))
       }
       summaryChaperoneProfileComboBox.currentIndex = 0
       summaryChaperoneProfileComboBox.model = profiles
    }


    function reloadVideoProfiles() {
       var profiles = [""]
       var profileCount = VideoTabController.getVideoProfileCount()
       for (var i = 0; i < profileCount; i++) {
           profiles.push(VideoTabController.getVideoProfileName(i))
       }
       summaryVideoProfileComboBox.currentIndex = 0
       summaryVideoProfileComboBox.model = profiles
    }
}
