import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page
    allowedOrientations: Orientation.All

    SilicaListView {
        anchors.fill: parent

        header: PageHeader {
            title: qsTr("Daily")
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }
        }

        model: ListModel {
            id: tasksModel
        }

        delegate: TextSwitch {
            text: taskDescription
            checked: taskDone
            onCheckedChanged: {
                if (checked) {
                    app.backend.mark_task_done(taskID)
                } else {
                    app.backend.undo_task(taskID)
                }
            }
        }
    }

    function reloadModel(tasks) {
        tasksModel.clear()
        for (var i = 0; i < tasks.length; i++) {
            tasksModel.append({ taskID: tasks[i].id, taskDescription: tasks[i].description, taskDone: (tasks[i].done || 0) })
        }
    }

    Connections {
        target: app
        onTasksUpdated: {
            reloadModel(tasks)
        }
    }


    Component.onCompleted: {
        reloadModel(app.backend.get_tasks())
    }
}

