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

                app.tasksRemaining = app.backend.get_undone_count()
            }
        }
    }

    Timer {
        interval: 15 * 60 * 1000 // 15 minutes
        running: true
        repeat: true
        onTriggered: {
            app.updateTasks(tasksModel)
        }
    }

    Component.onCompleted: {
        app.updateTasks(tasksModel)
    }
}

