import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"

ApplicationWindow
{
    id: app

    Backend {
        id: backendComponent
    }

    property var backend: backendComponent.daily
    property int tasksRemaining

    function updateTasks() {
        var tasks = app.backend.get_tasks()
        backendComponent.tasksUpdated(tasks)
    }

    Connections {
        target: backendComponent
        onTasksUpdated: {
            app.tasksRemaining = app.backend.get_undone_count()
        }
    }

    Component.onCompleted: {
        app.tasksRemaining = app.backend.get_undone_count()
    }

    Timer {
        interval: 15 * 60 * 1000 // 15 minutes
        running: true
        repeat: true
        onTriggered: {
            app.updateTasks()
        }
    }


    initialPage: Component { MainPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml", { backend: backendComponent.daily })
    allowedOrientations: defaultAllowedOrientations
}

