import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "harbour-daily.js" as Daily
import "pages"

ApplicationWindow
{
    id: app
    property var backend: new Daily.Daily(app)
    property int tasksRemaining
    signal tasksUpdated(var tasks)

    function updateTasks() {
        var tasks = app.backend.get_tasks()
        backendComponent.tasksUpdated(tasks)
    }

    onTasksUpdated: {
        app.tasksRemaining = backend.get_undone_count()
    }

    Component.onCompleted: {
        app.tasksRemaining = backend.get_undone_count()
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
    cover: Qt.resolvedUrl("cover/CoverPage.qml", { backend: backend })
    allowedOrientations: defaultAllowedOrientations
}

