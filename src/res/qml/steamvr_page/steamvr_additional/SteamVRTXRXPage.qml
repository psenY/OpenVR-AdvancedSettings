import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import ovras.advsettings 1.0
import "." // QTBUG-34418, singletons require explicit import to load qmldir file
import "../../common"



MyStackViewPage {
    ListModel{
        id: listModelRXTX
        ListElement{
            TX:"Controller"
            RX:"Reciever"
            Dev:"device"
            DT: "Dongle Type"
        }
    }
    headerText: "设备配对信息"
    content:
        ColumnLayout {
                spacing: 10
                Layout.fillWidth: true
                Layout.fillHeight: true
                RowLayout{
                    MyText{
                        text: "状态: "
                        Layout.preferredWidth: 200
                    }
                    MyText{
                        id: statusText
                        text: "准备配对"
                        Layout.fillWidth: true
                    }
                }

                RowLayout{
                    MyText{
                        text: "已使用的加密狗: "
                        Layout.preferredWidth: 200
                    }
                    MyText{
                        id: donglesUse
                        text: ""
                        Layout.preferredWidth: 100
                    }

                    Item{
                        Layout.fillWidth: true
                    }
                    MyPushButton{
                        Layout.preferredWidth: 250
                        text: "刷新设备列表"
                        id: searchButton
                        onClicked: {
                            getRXTX()
                        }
                    }
                }
                RowLayout{
                    MyText{
                        text: "操作说明：将设备设置为配对模式，然后点击所需未连接的加密狗进行配对。若要与当前已使用的加密狗配对，请先关闭已连接设备并刷新列表。"
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                    }
               }
                Rectangle {
                    color: "#ffffff"
                    height: 1
                    Layout.fillWidth: true
                    Layout.bottomMargin: 5
                }
                RowLayout{
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                        ListView{
                            id: lvDevInfo
                            model: listModelRXTX
                            spacing: 20
                            Layout.fillHeight: true
                            Layout.fillWidth:  true
                            clip: true
                            delegate:
                            GroupBox {
                                id: chaperoneTypeGroupBox
                                Layout.fillWidth: true

                                label: RowLayout{
                                    MyText {
                                        leftPadding: 10
                                        text: "设备: "
                                        bottomPadding: -10
                                    }
                                    MyText {
                                        leftPadding: 10
                                        text: Dev
                                        bottomPadding: -10
                                    }
                                }
                                background: Rectangle {
                                    color: "transparent"
                                    border.color: "#d9dbe0"
                                    radius: 8
                                }
                                ColumnLayout{
                                    anchors.fill: parent

                                    Rectangle {
                                        color: "#d9dbe0"
                                        height: 1
                                        Layout.fillWidth: true
                                        Layout.bottomMargin: 5
                                    }
                                    RowLayout{
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                        clip: true
                                        MyText{
                                            Layout.preferredWidth: 150
                                            text: "设备 ID: "
                                        }
                                        MyText{
                                            Layout.preferredWidth: 250
                                            text: TX
                                            clip: true
                                        }
                                        Item{
                                            Layout.preferredWidth: 50
                                        }
                                        MyText{
                                            Layout.preferredWidth: 300
                                            text: "已连接加密狗类型: "
                                        }
                                        MyText{
                                            Layout.preferredWidth: 250
                                            text: DT
                                            clip: true
                                        }
                                    }
                                    RowLayout{
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                        clip: true
                                        MyPushButton{
                                            Layout.preferredWidth: 200
                                            text: "配对"
                                            id: pairBtn
                                            onClicked: {
                                                SteamVRTabController.pairDevice(rxtext.text)
                                            }
                                            Component.onCompleted: {
                                                if(Dev != "No Connection"){
                                                    this.enabled = false;
                                                }
                                            }
                                        }

                                        Item{
                                            Layout.preferredWidth: 400
                                        }
                                        MyText{
                                            Layout.preferredWidth: 150
                                            text: "加密狗 ID: "
                                        }
                                        MyText{
                                            Layout.preferredWidth: 250
                                            id: rxtext
                                            text: RX
                                        }
                                    }
                                }
                        }
                        ScrollBar{
                        clip: true
                        visible: true}

                    }
                }
        }
    Component.onCompleted: {
        getRXTX()
    }
    Connections{
        target: SteamVRTabController
            onPairStatusChanged: {
                statusText.text = value;
                getRXTX()
            }
            onUpdateRXTX:{
                getRXTX()
            }

    }

    function getRXTX() {
        listModelRXTX.clear();
        SteamVRTabController.searchRXTX();
        donglesUse.text = SteamVRTabController.getDongleUsage();
        var pairCount = SteamVRTabController.getRXTXCount()
        for (var i = 0; i < pairCount; i++) {
            var RXget = SteamVRTabController.getRXList(i);
            var TXget = SteamVRTabController.getTXList(i);
            var nameGet = SteamVRTabController.getDeviceName(i)
            var dongletyp = SteamVRTabController.getDongleType(i)
            listModelRXTX.append({RX:RXget, TX:TXget, Dev:nameGet, DT:dongletyp})
        }
    }
}



    //TODO content

