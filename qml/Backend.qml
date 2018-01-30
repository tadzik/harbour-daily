import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import "harbour-daily.js" as Daily

Item {
    id: me
    property var daily: new Daily.Daily(me)
    signal tasksUpdated(var tasks)
}
