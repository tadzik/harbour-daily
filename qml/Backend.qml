import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import "harbour-daily.js" as Daily

Item {
    id: me
    property var daily

    Component.onCompleted: {
        me.daily = new Daily.Daily()
    }
}
