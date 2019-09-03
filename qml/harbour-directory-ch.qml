import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0
import "pages"

ApplicationWindow {
    id: main
    property string version: "1.0"
    property string dateTimeFormat: qsTr("d M yyyy '('hh':'mm')'")
    property string timeFormat: qsTr("hh':'mm")
    property alias dataModel: xmlSourceModel

    initialPage: Component { FirstPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    XmlListModel {
        id: xmlSourceModel
        query: "/feed/entry"

        XmlRole { name: "uuid"; query: "id/string()"; }
        XmlRole { name: "title"; query: "title/string()"; }
        XmlRole { name: "content"; query: "content/string()"; }
        XmlRole { name: "updated"; query: "updated/string()"; }
        XmlRole { name: "published"; query: "published/string()"; }
        XmlRole { name: "vCardSource"; query: 'link[@type="text/x-vcard"][1]/@href/string()'; }

        onStatusChanged: {
            if (status === XmlListModel.Error) print(errorString())
        }
    }
}
