import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page
    allowedOrientations: Orientation.All

    ListModel {
        id: tasksModel
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: header.height + innerColumn.height + listView.height

        Column {
            id: column
            anchors.fill: parent

            PageHeader {
                id: header
                title: qsTr("Settings")
            }

            Column {
                id: innerColumn
                width: parent.width

                TextField {
                    id: textField
                    width: parent.width * 3/4
                    anchors.horizontalCenter: parent.horizontalCenter
                    placeholderText: "Enter task name"
                }

                Button {
                    id: addButton
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Add a new task"
                    onClicked: {
                        app.backend.add_task(textField.text)
                        textField.text = ""
                        app.updateTasks(tasksModel)
                    }
                }
            }

            SilicaListView {
                id: listView
                height: tasksModel.count * Theme.itemSizeSmall
                width: parent.width
                model: tasksModel

                delegate: ListItem {
                    id: delegate

                    Label {
                        x: Theme.horizontalPageMargin
                        text: taskDescription
                    }

                    menu: ContextMenu {
                        MenuItem {
                            text: "Remove task"
                            onClicked: {
                                Remorse.itemAction(delegate, "Removing task '" + taskDescription + "'", function() {
                                    app.backend.remove_task(taskID)
                                     app.updateTasks(tasksModel)
                                })
                            }
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        app.updateTasks(tasksModel)
    }
}
