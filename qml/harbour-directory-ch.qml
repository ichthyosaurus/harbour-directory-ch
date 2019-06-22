import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"

ApplicationWindow {
    id: main
    property string version: "0.1"
    property string dateTimeFormat: qsTr("d M yyyy '('hh':'mm')'")
    property string timeFormat: qsTr("hh':'mm")

    initialPage: Component { FirstPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
}
