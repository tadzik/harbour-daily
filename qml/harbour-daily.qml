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

    function updateTasks(model) {
        var tasks = app.backend.get_tasks()
        model.clear()
        for (var i = 0; i < tasks.length; i++) {
            model.append({ taskID: tasks[i].id, taskDescription: tasks[i].description, taskDone: (tasks[i].done || 0) })
        }
        app.tasksRemaining = app.backend.get_undone_count()
    }


    initialPage: Component { MainPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml", { backend: backendComponent.daily })
    allowedOrientations: defaultAllowedOrientations
}

