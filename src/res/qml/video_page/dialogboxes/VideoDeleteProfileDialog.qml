import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import ovras.advsettings 1.0
import "../../common"

MyDialogOkCancelPopup {
    id: videoDeleteProfileDialog
    dialogWidth: 600
    dialogHeight: 300
    y: -200
    x: 0
    property int profileIndex: -1
    dialogTitle: "删除配置文件"
    dialogText: "您确定要删除此配置文件吗？"
    onClosed: {
        if (okClicked) {
            VideoTabController.deleteVideoProfile(profileIndex)
        }
    }
}
