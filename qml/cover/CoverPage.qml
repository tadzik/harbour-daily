import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    id: cover

    Column {
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        spacing: Theme.paddingMedium

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Theme.fontSizeExtraLarge
            text: qsTr("Daily") + "\n" // Hack, center it properly
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Theme.fontSizeExtraLarge
            text: "" + app.tasksRemaining + ""
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("tasks remaining") // Hack, center it properly
        }
    }
}

